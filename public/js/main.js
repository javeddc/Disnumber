console.log('yo');

var dis = {
  userInput: document.getElementById('user_input'),
  findBtn: document.getElementById('find_btn'),
  inputAlert: document.getElementById('input_alert'),
  copyPhraseBtn: document.getElementById('copy_phrase'),
  copyDigitsBtn: document.getElementById('copy_digits'),
  phraseText: document.getElementById('phrase_text'),
  digitsText: document.getElementById('digits_text'),
  alertBox: document.getElementById('notification'),
  alertText: document.getElementById('notification_text'),
  check_input: function() {
    console.log('beep');
    text = dis.userInput.value;
    text = text.replace(/-|,|\.|_/, ' ');
    if (text.replace(/[^A-Za-z\d +#*-\.]/g, '') != text) {
      dis.inputAlert.textContent = 'Please enter letters, numbers, or dialing characters (#*+-)';
      dis.inputAlert.style.visibility = 'visible';
      dis.btn_off()
    } else if ((/\d/g).test(text) && ((/[a-z]/ig).test(text))) {
      dis.inputAlert.textContent = 'Please enter a number OR a phrase';
      dis.inputAlert.style.visibility = 'visible';
      dis.btn_off()
    } else {
      dis.inputAlert.style.visibility = 'hidden';
      dis.btn_on()
    }

    text = text.replace(/[^A-Za-z\d +#*-]/, '')
    dis.userInput.value = text;
    console.log(text);
    patt = / /
  },
  btn_on: function() {
    dis.findBtn.disabled = false;
    dis.findBtn.classList.remove('disabled');
  },
  btn_off: function() {
    dis.findBtn.disabled = true;
    dis.findBtn.classList.add('disabled');
  },
  copyToClipboard: function(element) {
    var temp = document.createElement("input");
    // Get the text from the element passed into the input
    temp.setAttribute("value", element.innerHTML);
    // Append the aux input to the body
    document.body.appendChild(temp);
    // Highlight the content
    temp.select();
    // Execute the copy command
    document.execCommand("copy");
    // Remove the input from the body
    document.body.removeChild(temp);
    dis.popMessage('Copied to clipboard: ' + element.innerHTML)
  },
  popMessage(message) {
    dis.alertBox.style.display = 'block';
    dis.alertText.textContent = message;
    setTimeout(function(){dis.alertBox.style.display = 'none';}, 1400);
  }
}

dis.userInput.addEventListener('input', dis.check_input);
dis.copyPhraseBtn.addEventListener('click', function() {
  dis.copyToClipboard(dis.phraseText)
});
dis.copyDigitsBtn.addEventListener('click', function() {
  dis.copyToClipboard(dis.digitsText)
});
