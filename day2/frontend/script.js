function getMessage() {
    fetch("http://localhost:5000/api/message")
        .then(response => response.json())
        .then(data => {
            document.getElementById("output").innerText =
                data.message + " (from " + data.served_by + ")";
        })
        .catch(err => {
            document.getElementById("output").innerText = "Backend not reachable";
        });
}
