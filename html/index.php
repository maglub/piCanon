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


$app->get('/:route', function () use ($app) {
    #$app->render('index.html', ['plotConfig' => getDbPlotConfig(),'activePlugins' => getListOfActivePlugins()]);
    $readme = null;
    $readme = Parsedown::instance()->parse(
        file_get_contents(dirname(__DIR__) . '/README.md')
    );

    $app->render('index.html', ["readme" => $readme]);
})->conditions(array("route" => "(|home)"));

$app->get('/save', function() use ($app, $root) {
#  $files = array_diff(scandir('/home/pi/piCanon/save'), array('..', '.','.gitignore','thumbs'));
  $res = glob('/home/pi/piCanon/save/*.{jpg,jpeg,gif,png}', GLOB_BRACE);

  $files = [] ;
  foreach($res as $file){
    $files[] = basename($file); 
  }

  $app->render('save.html', ["files" => $files]);
});

  $app->run();

?>

