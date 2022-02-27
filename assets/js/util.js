
var optionContainer = document.getElementById("announcement-container");
var announcement = document.getElementById("announcement").addEventListener("click", function() {
    if(optionContainer.style.display === 'none') {
	optionContainer.style.display = 'block';
    } else if(optionContainer.style.display === 'block') {
	optionContainer.style.display = 'none';
    }
});

export {announcement}
