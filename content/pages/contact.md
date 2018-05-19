Title: Get In Touch
Date: 2012-03-30 12:16

<!-- markdownlint-disable MD033 -->
<style>
input[type=text], textarea, select {
    width: 100%;
    padding: 12px 20px;
    margin: 8px 0;
    display: inline-block;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
}

input[type=submit] {
    width: 100%;
    background-color: #d9411e;
    color: white;
    padding: 14px 20px;
    margin: 8px 0;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

input[type=submit]:hover {
    background-color: #e9613e;
}

div.contactForm {
    border-radius: 5px;
    background-color: #f2f2f2;
    padding: 20px;
}
</style>
Feel free to reach out to me using the form below.  Alternatively, feel free to DM me
on Twitter [@codependentcodr](https://www.twitter.com/codependentcodr)

<div class="contactForm">
    <form method="POST" action="https://formspree.io/getintouch@codependentcodr.com">
        <label for="fname">First Name</label>
        <input type="text" id="fname" name="firstname" placeholder="Your name.." required>

        <label for="lname">Last Name</label>
        <input type="text" id="lname" name="lastname" placeholder="Your last name.." required>

        <label for="email">Email</label>
        <input type="text" id="email" name="email" placeholder="Your email.." required>

        <label for="address">Message</label>
        <textarea name="address" id="address" rows="10" required></textarea>

        <input class="hidden" type="text" name="_gotcha" style="display:none">
        <input class="hidden" type="hidden" name="_subject" value="Message via http://www.codependentcodr.com">

        <input type="submit" value="Submit">
  </form>
</div>

<!-- markdownlint-enable MD033 -->
