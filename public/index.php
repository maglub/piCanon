<?php

        require_once("./stub.php");
        require_once($root . "myfunctions.inc.php");

        //set up environment for cli
        if (!(isset($_SERVER['DOCUMENT_ROOT']) && $_SERVER['DOCUMENT_ROOT'] !== "")) {
                $_SERVER['HTTP_HOST'] = "cron";
                // add ".." to the directory name to point to "./html"
                $_SERVER['DOCUMENT_ROOT'] = __DIR__ . "/..";
                $argv = $GLOBALS['argv'];
                array_shift($GLOBALS['argv']);
                #$pathInfo = implode('/', $argv);
                $pathInfo = $argv[0];
        }

        require_once($root."/vendor/autoload.php");

        #--- instantiate Slim and SlimJson
        $app = new \Slim\Slim(array(
             'templates.path' => 'templates')
          );

        //if run from the command-line
        if ($_SERVER['HTTP_HOST'] === "cron"){
                // Set up the environment so that Slim can route
                $app->environment = Slim\Environment::mock([
                    'PATH_INFO'   => $pathInfo
                ]);
        }


// define the engine used for the view
$app->view(new \Slim\Views\Twig());

// configure Twig template engine
$app->view->parserOptions = array(
   'charset' => 'utf-8',
   'cache' => realpath('templates/cache'),
   'auto_reload' => true,
   'strict_variables' => false,
   'autoescape' => true
);

$app->view->parserExtensions = array(new \Slim\Views\TwigExtension());

$twig = $app->view()->getEnvironment();
$twig->addGlobal('devicename', gethostname());


        #======== helper functions
        function o2h($obj){ #--- object to hash helper function (since json_encode cannot serialize php objects)
                $ret = Array();
                foreach($obj as $key => &$field){
                        if(is_object($field)){
                                $field = o2h($field);
                        }
                        $ret[$key] = $field;
                }
                return $ret;
        }



$app->get('/:route', function () use ($app) {
    $readme = Parsedown::instance()->parse(
        file_get_contents(dirname(__DIR__) . '/README.md')
    );

    $app->render('index.html', ["readme" => $readme]);
})->conditions(array("route" => "(|home)"));

#======================================
# /save
#======================================
$app->get('/save', function() use ($app, $root) {
  $files = getSaveFiles();

  $app->render('save.html', ["files" => $files["basename"]]);
});

#======================================
# /config
#======================================
$app->map('/config', function() use ($app, $root){
  $res=null;

  if ($app->request()->isPost()) {

    $action = $app->request->post('action');
    switch ($action) {
      case "thumbnails":
        $res = shell_exec("sudo -u pi ${root}/../bin/wrapper genThumbnailsBG > /dev/null 2>&1");
        break;
       
      case "timelapse":
        $interval = $app->request->post('interval');
        if ($interval == "Off") {
          $res = shell_exec("sudo -u pi ${root}/../bin/wrapper disableCrontab 2>/dev/null");
        } else {
          $res = shell_exec("sudo -u pi ${root}/../bin/wrapper setCrontab {$interval} 2>/dev/null");
        }
        break;
    }
    $app->redirect('/config');
  }
  

  $camera = shell_exec("sudo -u pi ${root}/../bin/wrapper getCamera 2>/dev/null");
  $cameraConfigJson = shell_exec("sudo -u pi ${root}/../bin/wrapper getCameraConfig 2>/dev/null");
#  var_dump($cameraConfigJson);
  $cameraConfig = json_decode($cameraConfigJson); 
#  var_dump($cameraConfig);
  $crontab = shell_exec("sudo -u pi ${root}/../bin/wrapper getCrontab 2>/dev/null");
  $processes = shell_exec("sudo -u pi ${root}/../bin/wrapper getProcessQueue 2>/dev/null");

  $app->render('config.html', ["crontab" => $crontab, "camera" => $camera, "processes" => $processes, "camera_config" => o2h($cameraConfig) ]);
})->via('GET', 'POST')->name('config');

  $app->run();

?>

