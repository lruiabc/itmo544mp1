<?php
print "Hello world!";
?>
<html>
<head>
<title>Hello app</title>
</head>
<body>
<form enctype="multipart/form-data" action="result.php" method="POST">
	<input type="hidden" name="MAX_FILE_SIZE" value="30000000" />
	send this file:<input name="userfile" type="file" /><br>
Enter name of user:<input type="name" name="uname"><br>
Enter Email of user:<input type="email" name="useremail"><br>
Enter Phone of user (1-XXX-XXX-XXXX):<input type="phone" name="phone">

<input type="submit" value="Send File"/>
</form>
<hr />
<form enctype="multipart/form-data" action="gallary.php" method="POST">
Enter Email of user for gallery to browse:<input type="email" name="email">
<input type="submit" value="Load Gallery" />
</form>

hello<?php print "world"; ?>
</body>
</html>