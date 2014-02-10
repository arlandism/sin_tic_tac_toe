function SuggestionBox(id){
        this.box = document.getElementById("suggestion_box");
}

SuggestionBox.prototype.moveSuggestion = function(moveNum){
        var message = "I wouldn't move to " + moveNum + " if I were you!";
        this.box.textContent = message;
        this.box.hidden = false;
}

SuggestionBox.prototype.hide = function(){
        this.box.hidden = true;
}

SuggestionBox.prototype.requestMoveEvaluation = function(moveNum, piece){
}

var changeSuggestion = function(message){
        var suggestionBox = document.getElementById("suggestion_box");
        suggestionBox.textContent = message;
        suggestionBox.hidden = false;
}

var attachMoveCallbacks = function(suggestionBox, moveNum){
        var selectedMove = document.getElementById(String(moveNum));
        selectedMove.onmouseover= function(){
                suggestionBox.moveSuggestion(moveNum);
        }
        selectedMove.onmouseout = function() { suggestionBox.hide(); }
}

window.onload = function(){
        var suggestionBox = new SuggestionBox("suggestion_box");
        for(i = 1; i < 10; i++){
                attachMoveCallbacks(suggestionBox, i);
        }
}
