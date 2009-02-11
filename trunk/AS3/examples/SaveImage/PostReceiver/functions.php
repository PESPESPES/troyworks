<?php

function errorMessage($msg)
{
    header("HTTP/1.1 500 $msg");
    exit;
}

function getParam($key)
{
    static $params = null;

    if ($params === null) {
        $query = substr($_SERVER['REQUEST_URI'], strpos($_SERVER['REQUEST_URI'], '?') + 1);
        $params = array();
        parse_str($query, $params);
    }

    if (isset($params[$key])) {
        return $params[$key];
    }
}

/**
 * Delete a file, or a folder and its contents
 *
 * @author      Aidan Lister <aidan@php.net>
 * @version     1.0.3
 * @link        http://aidanlister.com/repos/v/function.rmdirr.php
 * @param       string   $dirname    Directory to delete
 * @return      bool     Returns TRUE on success, FALSE on failure
 */
function rmdirr($dirname)
{
    // Sanity check
    if (!file_exists($dirname)) {
        return false;
    }

    // Simple delete for a file
    if (is_file($dirname) || is_link($dirname)) {
        return unlink($dirname);
    }

    // Loop through the folder
    $dir = dir($dirname);
    while (false !== $entry = $dir->read()) {
        // Skip pointers
        if ($entry == '.' || $entry == '..') {
            continue;
        }

        // Recurse
        rmdirr($dirname . DIRECTORY_SEPARATOR . $entry);
    }

    // Clean up
    $dir->close();
    return rmdir($dirname);
}

/**
 * Copy a file, or recursively copy a folder and its contents
 *
 * @author      Aidan Lister <aidan@php.net>
 * @version     1.0.1
 * @link        http://aidanlister.com/repos/v/function.copyr.php
 * @param       string   $source    Source path
 * @param       string   $dest      Destination path
 * @return      bool     Returns TRUE on success, FALSE on failure
 */
function copyr($source, $dest, $overwrite = false)
{
    // Simple copy for a file
    if (is_file($source)) {
        return copy($source, $dest);
    }

    // Make destination directory
    if (!is_dir($dest)) {
        mkdir($dest);
    }

    // If the source is a symlink
    if (is_link($source)) {
        $link_dest = readlink($source);
        return symlink($link_dest, $dest);
    }

    // Loop through the folder
    $dir = dir($source);
    while (false !== $entry = $dir->read()) {
        // Skip pointers
        if ($entry == '.' || $entry == '..') {
            continue;
        }

        // Deep copy directories
        if ($dest !== "$source/$entry") {
            if ($overwrite || !is_file("$dest/$entry")) {
                copyr("$source/$entry", "$dest/$entry");
            } else {
                return false;
            }
        }
    }

    // Clean up
    $dir->close();
    return true;
}

/**
 * Check if a directory is empty
 */
function is_dir_empty($dirPath)
{
    if (!is_dir($dirPath)) {
        return null;
    }

    $dirEmpty = true;
    // Check for any contents in the folder
    $dir = dir($dirPath);
    while (false !== $entry = $dir->read()) {
        // Skip pointers
        if ($entry == '.' || $entry == '..') {
            continue;
        }
        $dirEmpty = false;
	break;
    }
    $dir->close();
    return $dirEmpty;
}

/**
 * Move files (copyr with delete)
 */
function mover($source, $dest, $overwrite = false)
{
    $a1 = copyr($source, $dest, $overwrite);
    if (!$a1) {
        return false;
    }

    $a2 = rmdirr($source);
    return $a2;
}
