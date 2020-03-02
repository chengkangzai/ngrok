<?php
include "config.php";
$ngrok = $_POST['ngrok'];
$vpnIP = $_POST['vpnIP'];
$protocol = $_POST['protocol'];
$pcName = $_POST['pcName'];

if (empty($ngrok)) {
    echo "ngrok is empty!\n";
} else {
    echo "ngrok :\t'$ngrok'\n";
}
if (empty($vpnIP)) {
    echo "vpnIP is empty!\n";
} else {
    echo "VPN IP :\t'$vpnIP'\n";
}
if (empty($protocol)) {
    echo "protocol is empty!\n";
} else {
    echo "Protocol :\t'$protocol'\n";
}
if (empty($pcName)) {
    echo "pcName is empty!\n";
} else {
    echo "PC Name :\t'$pcName'\n";
}

$sql = "SELECT * from ngrok where pcname=?";
if ($stmt = mysqli_prepare($db, $sql)) {
    mysqli_stmt_bind_param($stmt, "s", $pcName);
    $result = mysqli_stmt_execute($stmt);
    if ($result) {
        $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
        mysqli_stmt_store_result($stmt);
        if (mysqli_stmt_num_rows($stmt) >= 1) {
            $existInDatabase = true;
        }
    }
}

$timeStamp=date('d/m/Y h:i a');
echo "Current time is $timeStamp. \n";

if ($existInDatabase == true) {
    //Exist in database
    $sql = "UPDATE `ngrok` SET `ngrok`=?,`vpn`=?,`protocol`=?,`timestamp`=? WHERE `pcname`=?";

    if ($stmt = mysqli_prepare($db, $sql)) {
        mysqli_stmt_bind_param($stmt, "sssss",$ngrok,$vpnIP ,$protocol,$timeStamp,$pcName);
        if(mysqli_stmt_execute($stmt)){
            echo "Success update Heartbeat. ";
        }else{
            echo "Error when execute sql statement.";
        }
    }else{
        echo"Error when preparing sql statement. \n Check your sql statement.";
    }
} else {
    $sql = "INSERT INTO `ngrok`(`ngrok`, `vpn`, `protocol`, `pcname`,`timestamp`) VALUES (?,?,?,?,?)";

    if ($stmt = mysqli_prepare($db, $sql)) {
        mysqli_stmt_bind_param($stmt, "sssss",$ngrok,$vpnIP ,$protocol,$pcName,$timeStamp);
        if(mysqli_stmt_execute($stmt)){
            echo "Success Add PC to database.";
        }else{
            echo "Error when execute sql statement.";
        }
    }else{
        echo"Error when preparing sql statement. \n Check your sql statement.";
    }
}
