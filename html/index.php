<?php

require('../vendor/autoload.php');

header('Content-Type: text/plain');
print file_get_contents('time') . "\n";

$hello = new Rivsen\Demo\Hello();
echo $hello->hello();
