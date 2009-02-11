<?php

file_put_contents('request.log', print_r($_REQUEST, 1));

include 'functions.php';

// Data storage directory - needs to be httpd writable
define('DATA_DIR', 'data');

// Max requested file path length
define('MAX_PATH_LENTH', 60);

// Determine read / write
$mode = 'read';
$smode = getParam('mode');

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    switch ($smode)
    {
        case 'stat':
            $mode = 'stat';
            break;

        case 'list':
            $mode = 'list';
            break;

        case '':
            $mode = 'read';
            break;

        default:
            errorMessage("Invalid mode for this request type");
            break;
    }
} else {
    switch ($smode)
    {
        case 'delete':
            $mode = 'delete';
            break;

        case 'write':
        case 'append':
        case 'update':
        case 'copy':
        case 'move':
        case 'mkdir':
        case 'touch':
            $mode = 'write';
            break;

        default:
            errorMessage("Invalid mode for this request type");
            break;
    }
}

$requestFile = DATA_DIR . $_GET['data'];

//var_dump($requestFile);

// Verify file path
if (strlen($requestFile) > MAX_PATH_LENTH || preg_match("!([^a-z0-9/\._-])!i", $requestFile)) {
    errorMessage('File path error');
}

if ($mode == 'write' && in_array($smode, array('write', 'append', 'update'))) {

    // Read post content
    $fp = fopen('php://input', 'r');

    // Create subdirectories
    $dir = dirname($requestFile);
    if (!file_exists($dir)) {
        mkdir($dir, 0777, true);
    }

    // Determine write mode
    if ($smode == "append") {
        $fmode = 'a';
    } elseif ($smode == "update") {
        $fmode = 'r+';
    } else {
        $fmode = 'w';
    }

    // Write
    $fw = fopen($requestFile, $fmode);

    if (getParam('position')) {
        fseek($fw, getParam('position'));
    }

    while (!feof($fp)) {
        fwrite($fw, fread($fp, 8192) );
    }
}

if ($mode == 'write' && in_array($smode, array('copy', 'move'))) {
    $dst = DATA_DIR . '/' . getParam('dst');

    // Verify destination path
    if (strlen($requestFile) > MAX_PATH_LENTH || preg_match("!([^a-z0-9/\._-]|\.{2,}|/{2,})!i", $requestFile)) {
        errorMessage('Destination file path error');
    }

    // Source path access
    if (!is_readable($requestFile)) {
        errorMessage('Source file not readable');
    }

    // Destination file access
    if (file_exists($dst) && !is_writable($dst)) {
        errorMessage('Destination path not writable');
    }

    // dir to file error
    if (is_dir($requestFile) && file_exists($dst) && !is_dir($dst)) {
        errorMessage('Unable to move/copy directory into file');
    }

    $overwrite = getParam('overwrite');

    switch ($smode) {
        case 'move':
            if (file_exists($dst) && is_dir($dst)) {
                $dst .= '/' . basename($requestFile);
            }

            if (!mover($requestFile, $dst, $overwrite)) {
                errorMessage('Move operation failed (invalid destination path/privileges?)');
            }
            break;

        case 'copy':
            if (!copyr($requestFile, $dst, $overwrite)) {
                errorMessage('Copy operation failed');
            }
            break;
    }
}

if ($mode == 'write' && in_array($smode, array('mkdir'))) {
    if (!file_exists($requestFile)) {
        mkdir($requestFile, 0777, true);
    }
}

if ($mode == 'write' && in_array($smode, array('touch'))) {
    if (!file_exists($requestFile) || is_writable($requestFile)) {
        touch($requestFile);
    } else {
        errorMessage('File not writable');
    }
}

if ($mode == 'read') {

    if (!is_readable($requestFile)) {
        errorMessage('File does not exist');
    }

    $fp = fopen($requestFile, 'r');
    fpassthru($fp);
}

if ($mode == 'stat') {
    $stats = array();

    if (!is_readable($requestFile)) {
        $stats['exists'] = 0;
    } else {
        $stats['exists'] = 1;
        $fstat = stat($requestFile);
        $stats['directory'] = is_dir($requestFile) ? '1' : '0';
        $stats['link'] = is_link($requestFile) ? '1' : '0';
        $stats['size'] = $fstat['size'];
        $stats['atime'] = $fstat['atime'];
        $stats['mtime'] = $fstat['mtime'];
        $stats['ctime'] = $fstat['ctime'];
    }

    foreach ($stats as $k => $v) {
        echo "$k: $v\n";
    }
}

if ($mode == 'delete') {

    // Remove directory contents
    $rmContents = getParam('rf');
    if (file_exists($requestFile)) {
        if (!is_writable($requestFile)) {
            errorMessage('File not deletable');
        } else {
            if (is_file($requestFile)) {
                $bResult = unlink($requestFile);
            } elseif (is_dir($requestFile)) {
                if ($rmContents) {
                    $bResult = rmdirr($requestFile);
                } else {
                    if (is_dir_empty($requestFile)) {
                        $bResult = rmdir($requestFile);
                    } else {
                        errorMessage("Directory not empty");
                    }
                }
            }
        }
    }

    if (empty($bResult)) {
        errorMessage("Delete operation failed");
    }
}

if ($mode == 'list') {

    if (is_file($requestFile) || !file_exists($requestFile)) {
        errorMessage("Invalid directory");
    }

    // Filename, Size, Modtime, isDir, isSymlink

    // Loop through the folder
    $stats = array();
    $dir = dir($requestFile);
    while (false !== $entry = $dir->read()) {
        // Skip pointers
        if ($entry == '.' || $entry == '..') {
            continue;
        }

        // Fetch file status
        $dirFile = $requestFile . '/' . $entry;
        $stat = array();
        $fstat = stat($dirFile);
        $stat['directory'] = is_dir($dirFile) ? '1' : '0';
        $stat['link'] = is_link($dirFile) ? '1' : '0';
        $stat['size'] = $fstat['size'];
        $stat['atime'] = $fstat['atime'];
        $stat['mtime'] = $fstat['mtime'];
        $stat['ctime'] = $fstat['ctime'];
        $stats[$entry] = $stat;
    }

    // Clean up
    $dir->close();

    // Output file list
    $first = true;
    foreach ($stats as $file => $stat) {

        if (!$first) {
            echo "\n\n";
        } else {
            $first = false;
        }

        // Escape filename - nl will be a delimiter
        $file = str_replace("\\n", "\\\\n", $file);
        print str_replace("\n", "\\n", $file) . "\n";
        print join("\n", $stat);
    }

}




