<?php
function generateRandNoWithLength( $len) {
    $rand   = '';
    while( !( isset( $rand[$len-1] ) ) ) {
        $rand   .= mt_rand( );
    }
    return substr( $rand , 0 , $len );
}
 ?>
