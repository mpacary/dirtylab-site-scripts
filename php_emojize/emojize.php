<?php

// inspired from https://github.com/carpedm20/emoji
// converts emoji codes such as :smile: int to their <img src="xxxx.png"> equivalent on GitHub CDN

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

// handle :some_emoji:

$content = preg_replace_callback('/:([a-zA-Z0-9\+\-_&.ô’Åéãíç]+):/', function ($match) {
      global $g_emoji_unicode;

      $str_code = $match[1];

      if (!isset($g_emoji_unicode[$str_code]))
        return ':'.$str_code.':';

      $unicode_code = $g_emoji_unicode[$str_code];

      $unicode_image_name = ltrim(strtolower($unicode_code), "\\Uu0").'.png';

      return '<img class="emoji" title=":'.$match[1].':" alt=":'.$match[1].':" src="'.EMOJI_PNG_ROOT.$unicode_image_name.'" height="20" width="20" align="absmiddle" />';
  }, $content);

// handle <unicode character>
// see http://stackoverflow.com/a/10584493/488666
// see https://en.wikipedia.org/wiki/Emoji#Unicode_Blocks

$content = preg_replace_callback('/['.
    unichr(0x1F300).'-'.unichr(0x1F5FF).
    unichr(0x1F600).'-'.unichr(0x1F64F).
    unichr(0x1F680).'-'.unichr(0x1F6F3).
    unichr(0x1F910).'-'.unichr(0x1F918).
    unichr(0x1F980).'-'.unichr(0x1F984).
    unichr(0x1F9C0).
    unichr(0x2600).'-'.unichr(0x27BF).
  ']/u', function ($match) {
      
      //echo "*** found '".$match[0]."'\n";
      
      $unicode_image_name = strtolower(dechex(intval(uniord($match[0])))).'.png';
      
      //echo "*** unicode_image_name '".$unicode_image_name."'\n";
      
      return '<img class="emoji" src="'.EMOJI_PNG_ROOT.$unicode_image_name.'" height="20" width="20" align="absmiddle" />';

}, $content);

file_put_contents($file_to_convert, $content);



// -----------------------------------------

function unichr($i)
{
  return iconv('UCS-4LE', 'UTF-8', pack('V', $i));
}

// found at http://www.php.net/manual/en/function.ord.php
function uniord($string, &$offset = 0)
{
  $code = ord(substr($string, $offset,1)); 
  if ($code >= 128) {        //otherwise 0xxxxxxx
    if ($code < 224) $bytesnumber = 2;                //110xxxxx
    else if ($code < 240) $bytesnumber = 3;        //1110xxxx
    else if ($code < 248) $bytesnumber = 4;    //11110xxx
    $codetemp = $code - 192 - ($bytesnumber > 2 ? 32 : 0) - ($bytesnumber > 3 ? 16 : 0);
    for ($i = 2; $i <= $bytesnumber; $i++) {
      $offset ++;
      $code2 = ord(substr($string, $offset, 1)) - 128;        //10xxxxxx
      $codetemp = $codetemp*64 + $code2;
    }
    $code = $codetemp;
  }
  $offset += 1;
  if ($offset >= strlen($string)) $offset = -1;
  return $code;
}
