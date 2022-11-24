/* side bar drawer */
let sideNav = document.getElementById("mySidenav")

/* Set side bar width 240px */
let openNav = document.getElementById("openNav").addEventListener("click", () => {
    sideNav.style.width = "240px";
})


/* Set the width of the side navigation to 0 */

let closeNav = document.getElementById("closeNav").addEventListener("click", () => {
    sideNav.style.width = "0";
})


var optionContainer = document.getElementById("announcement-container");
var announcement = document.getElementById("announcement").addEventListener("click", function() {
    if(optionContainer.style.display === 'none') {
	optionContainer.style.display = 'block';
    } else if(optionContainer.style.display === 'block') {
	optionContainer.style.display = 'none';
    }
});

export {openNav, closeNav, announcement}
