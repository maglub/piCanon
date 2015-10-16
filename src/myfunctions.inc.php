<?php
function getSaveFiles(){
  $res = glob('/home/pi/piSnapper/save/*.{jpg,jpeg,gif,png}', GLOB_BRACE);

  array_multisort(
    array_map( 'filemtime', $res ),
    SORT_NUMERIC,
    SORT_ASC,
    $res
  );

  $files = array( "basename" => [], "path" => [] ) ;
  foreach($res as $file){
    $files["basename"][] = basename($file);
    $files["path"][] =$file;
  }

  $files["basename"] = array_diff($files["basename"], array('latest.jpg'));

  return $files;
}
?>
