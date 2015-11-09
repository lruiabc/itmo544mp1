<?php

date_default_timezone_set('America/Chicago');
//start the session
session_start();
//echo $_FILES;
echo $_POST['uname'];
echo $_POST['useremail'];
echo $_POST['phone'];
$uploaddir='/tmp/';
$uploadfile = $uploaddir . basename($_FILES['userfile']['name']);
echo '<pre>';
if(move_uploaded_file($_FILES['userfile']['tmp_name'],$uploadfile)){
	echo "File is calid, and was successfully uploaded.\n";
}else{
	echo "Possible file upload attack!\n";
}
echo 'Here is some more debugging info:';
print_r($_FILES);
print "</pre>";
require 'vendor/autoload.php';
use Aws\S3\S3Client;
$client = S3Client::factory(array(
'version' =>'latest',
'region'  => 'us-west-2'
));
$bucket = uniqid("php-jrh-",false);
$result = $client->createBucket(array(
	'Bucket'=> $bucket
));
$client->waitUntil('BucketExists', array('Bucket' => $bucket));
//$client->waitUntilBucketExists(array('Bucket' => $bucket));
$key = $uploadfile;
$result = $client->putObject(array(
	'ACL'=>'public-read',
	'Bucket'=>$bucket,
	'Key'=>$key,
	'SourceFile'=> $uploadfile
));
$url = $result['ObjectURL'];
echo $url;
use Aws\Rds\RdsClient;
$client = RdsClient::factory(array(
'version' =>'latest',	
'region' => 'us-west-2'
));


$link = mysqli_connect("itmo544grh-mp1.ckh0wwv6itjw.us-west-2.rds.amazonaws.com","rui","110224Fish","itmoruidb") or die("Error " . mysqli_error($link));
/* check connection */
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}
//check connection
//if (mysqli_connect_error()){
//	printf("Connect failed: %s\n",mysqli_connect_error());
//	exit();0
//}
//prepared statement, stage1:prepare
if(!($stmt =$link->prepare("INSERT INTO items (id,uname,email,phone,filename,s3rawurl,s3finishedurl,status,issubscribed,timestamp)VALUES(NULL,?,?,?,?,?,?,?,?,?)"))){
	echo "Prepare failed:(" . $link->errno . ")" . $link->error;
}
$name = $_POST['uname'];
$email = $_POST['useremail'];
$phone = $_POST['phone'];
$s3rawurl = $result['ObjectURL'];//;from above
$filename = basename($_FILES['userfile']['name']);
$s3finishedurl = "none";
$status=0;
$issubscribed=0;
$date_time = time()
$stmt->bind_param("sssssii",$name,$email,$phone,$filename,$s3rawurl,$s3finishedurl,$status,$issubscribed,$date_time);
if(!$stmt->execute()){
	echo "Execute failed:(" . $stmt->errno . ")" . $stmt->error;
}
printf("%d Row inserted.\n", $stmt->affected_rows);
$stmt->close();
$link->real_query("SELECT * FROM items");
$res = $link->use_result();
echo "Result set order...\n";
while ($row = $res->fetch_assoc()){
	echo $row['id'] . " " .$row['email']. " " .$row['phone'];
}
$link->close();
?>