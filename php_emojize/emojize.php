<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

include dirname(__FILE__).'/emoji_codes.php';

define('EMOJI_PNG_ROOT', 'https://assets-cdn.github.com/images/icons/emoji/unicode/');


if (!isset($argv[1]))
{
  echo "Error: please provide a filename to process. Usage: php emojize.php <filename>\n";
  exit;
}


$file_to_convert = $argv[1];

echo "*** emojize.php: converting emoji codes for file '".$file_to_convert."'\n";

if (!file_exists($file_to_convert))
{
  echo "Error: file '".$file_to_convert."' does not exists";
  exit;
}

$content = file_get_contents($file_to_convert);

$content = preg_replace_callback('/:([a-zA-Z0-9\+\-_&.ô’Åéãíç]+):/', function ($match) {
      global $g_emoji_unicode;
      
      $str_code = $match[1];

      if (!isset($g_emoji_unicode[$str_code]))
        return ':'.$str_code.':';

      $unicode_code = $g_emoji_unicode[$str_code];

      $unicode_image_name = ltrim(strtolower($unicode_code), "\\Uu0").'.png';

      return '<img class="emoji" title=":'.$match[1].':" alt=":'.$match[1].':" src="'.EMOJI_PNG_ROOT.$unicode_image_name.'" height="20" width="20" align="absmiddle" />';
  }, $content);

file_put_contents($file_to_convert, $content);
