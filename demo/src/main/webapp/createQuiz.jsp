<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Create New Quiz</title>
</head>
<body>
<h2>Create a New Quiz</h2>

<form action="submit-quiz" method="post">
    <label>Title:</label><br/>
    <input type="text" name="title" required><br/><br/>

    <label>Description:</label><br/>
    <textarea name="description" rows="4" cols="50"></textarea><br/><br/>

    <label>Category ID (for now):</label><br/>
    <input type="number" name="categoryId"><br/><br/>

    <button type="submit">Create Quiz</button>
</form>

</body>
</html>
