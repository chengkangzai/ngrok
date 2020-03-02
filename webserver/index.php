<?php
include "config.php";
$sql = "SELECT * from ngrok";
$query = mysqli_query($db, $sql);
while ($row = mysqli_fetch_assoc($query)) {
    $ran = rand();
    if ($row['vpn'] == NULL) {
        $VPNDom = "";
        $VPNBtn ="";
    } else {
        $VPNDom = "<p class='card-text' id='VPN_$ran'>The vpn is :{$row['vpn']} </p>
        <input value='{$row['vpn']}' id='VPNInput_$ran' style='display:none'> ";
        $VPNBtn="<a id='copyVPN_$ran' class='mt-1 btn btn-primary text-white' onclick='copyVPNAddress($ran)' role='button'>Copy VPN</a>";
    }
    $cardDom .= "
<div class='card m-2' style='width: 18rem;'>
    <div class='card-body'>
        <h5 class='card-title'>{$row['pcname']}</h5>
        <p class='card-text' id='ngrokID_$ran'>{$row['ngrok']} </p>
        <input value='{$row['ngrok']}' id='ngrokInput_$ran' style='display:none'>
        $VPNDom
        <p class='card-text' >The protocol is: <span id='protocol_$ran'>{$row['protocol']}</span> </p>
        <p class='card-text'>Last seen: {$row['timestamp']} </p>
        <a id='copyNgrok_$ran' class='mt-1 btn btn-primary text-white' onclick='copyTunnelAddress($ran)' role='button'>Copy ngrok tunnel</a>
        $VPNBtn
    </div>
</div>";
};
?>
<!doctype html>
<html lang="en">

<head>
    <title>Ngrok Updater ! </title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>

<body>
    <div class="row m-0">
        <?php echo $cardDom; ?>
    </div>
    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

    <script>
        function copyTunnelAddress(id) {
            var ngrok = $(`#ngrokID_${id}`).text();
            var protocol = $(`#protocol_${id}`).text();
            ngrok = ngrok.split(protocol + '://');
            document.getElementById(`ngrokInput_${id}`).value = ngrok[1];
            $(`#ngrokInput_${id}`).show();
            var copyText = document.getElementById(`ngrokInput_${id}`);

            /* Select the text field */
            copyText.select();
            copyText.setSelectionRange(0, 99999); /*For mobile devices*/

            document.execCommand("copy");

            $(`#ngrokInput_${id}`).hide();
            var vpnBtn = $(`#copyVPN_${id}`);
            if (vpnBtn.hasClass("btn-info")) {
                vpnBtn.removeClass("btn-info").addClass("btn-primary");
                $(`#copyNgrok_${id}`).removeClass("btn-primary").addClass("btn-info");
            }
            $(`#copyNgrok_${id}`).removeClass("btn-primary").addClass("btn-info");

        }

        function copyVPNAddress(id) {
            $(`#VPNInput_${id}`).show();

            var copyText = document.getElementById(`VPNInput_${id}`);

            /* Select the text field */
            copyText.select();
            copyText.setSelectionRange(0, 99999); /*For mobile devices*/

            document.execCommand("copy");

            $(`#VPNInput_${id}`).hide();
            var ngrokBtn = $(`#copyNgrok_${id}`)
            if (ngrokBtn.hasClass("btn-info")) {
                ngrokBtn.removeClass("btn-info").addClass("btn-primary");
            }
            $(`#copyVPN_${id}`).removeClass("btn-primary").addClass("btn-info");

        }
    </script>
</body>

</html>