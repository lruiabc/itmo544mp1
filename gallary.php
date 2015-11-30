

<?php
session_start();
$email = $_POST["email"];
echo $email;
require 'vendor/autoload.php';
use Aws\Rds\RdsClient;

$client = RdsClient::factory(array(
'version' =>'latest',
'region'  => 'us-west-2'

));
$result = $client->describeDBInstances(array(

  'DBInstanceIdentifier' => 'itmo544grh-mp1',

));
$endpoint = $result['DBInstances'][0]['Endpoint']['Address'];
print "=". $endpoint . "=";

$link = mysqli_connect($endpoint,"rui","110224Fish","itmoruidb") or die("Error " . mysqli_error($link));
/* check connection */
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}
//below line is unsafe - $email is not checked for SQL injection -- don't do this in real life or use an ORM instead
$link->real_query("SELECT * FROM items WHERE email = '$email'");
//$link->real_query("SELECT * FROM items");
$res = $link->use_result();
echo "Result set order...\n";
while ($row = $res->fetch_assoc()) {
    echo "<img src =\" " . $row['s3rawurl'] . "\" /><img src =\"" .$row['s3finishedurl'] . "\"/>";
echo $row['id'] . "Email: " . $row['email'] ."uname:" . $row['uname'];

//$image=new Imagick(realpath($row['s3rawurl']));
//$image->thumbnaiImage(100,0);
//echo  $image;
}
$link->close();


?>
