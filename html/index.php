<?php

require('../vendor/autoload.php');

header('Content-Type: text/plain');
print file_get_contents('time') . "\n";

new wangcj\helloworld\helloworld();