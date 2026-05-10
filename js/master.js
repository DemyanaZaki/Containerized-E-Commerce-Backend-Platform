// --------------------- Settigns Box ---------------------
let settingsBox = document.querySelector(".settings-box");
let gearToggle = document.querySelector(".gear-toggle");
let gearI = document.querySelector(".gear-toggle > i");

gearToggle.addEventListener("click", function () {
  settingsBox.classList.toggle("open");
  gearI.classList.toggle("fa-spin");
});

window.addEventListener("keyup", (e) => {
  if (settingsBox.classList.contains("open")) {
    settingsBox.classList.toggle("open");
    gearI.classList.toggle("fa-spin");
  }
});
/* if user click not on settingsBox toggele and if it's open 
settingsBox.addEventListener("click", (e) => {
  if (settingsBox.classList.contains("open") && e.target) {
    console.log("win clicked");
    console.log(e.target);
    // settingsBox.classList.toggle("open");
    // gearI.classList.toggle("fa-spin");
  }
});
*/
// --------------------- Switch Colors
const colorsList = document.querySelectorAll(".colors-list li");
const colorsListLS = localStorage.getItem("colorsOption");

// check color in localStorage
if (colorsListLS) {
  document.documentElement.style.setProperty("--color-main", colorsListLS);
  // remove active class from all li:
  colorsList.forEach((elem) => {
    elem.classList.remove("active");

    // add active class with Data-color from localStorage
    if (elem.dataset.color === colorsListLS) {
      elem.classList.add("active");
    }
  });
}

colorsList.forEach((li) => {
  li.addEventListener("click", (e) => {
    // set color on root:
    document.documentElement.style.setProperty(
      "--color-main",
      e.target.dataset.color
    );
    // set chosen color in localStorage:
    localStorage.setItem("colorsOption", e.target.dataset.color);

    HandleActivStat(e);
  });
});
// Switch Colors ---------------------
// --------------------- Switch Random Background
// random background option
let backgroundOption = true;
let theInterval;

// --------------------- Random Background in localStorage
let backgroundLocalItem = localStorage.getItem("backgroundOption");
if (backgroundLocalItem) {
  backgroundOption = backgroundLocalItem;
  //remove active classes
  document.querySelectorAll(".random-back span").forEach((element) => {
    element.classList.remove("active");
  });
  // add active class
  if (backgroundLocalItem === "true") {
    document.querySelector(".random-back .yes").classList.add("active");
  } else {
    document.querySelector(".random-back .no").classList.add("active");
  }
}

const randomBack = document.querySelectorAll(".random-back span");

randomBack.forEach((span) => {
  span.addEventListener("click", (e) => {
    HandleActivStat(e);

    if (e.target.dataset.randmback === "yes") {
      backgroundOption = true;
      randomBackgr();
      localStorage.setItem("backgroundOption", true);
    } else {
      backgroundOption = false;
      clearInterval(theInterval);
      localStorage.setItem("backgroundOption", false);
    }
  });
});
// Switch Random Background ---------------------
// reset options:
document.querySelector(".reset-option").onclick = function () {
  localStorage.removeItem("backgroundOption");
  localStorage.removeItem("colorsOption");
  localStorage.removeItem("bulletOption");
  window.location.reload();
};
// Settigns Box --------------------- ---------------------

// --------------------- Landing Page ---------------------
const landingPage = document.querySelector(".landing-page");
// get array of images
let imgArray = [];
for (let i = 0; i < 5; i++) {
  imgArray.push(`./images/landing${i + 1}.jpg`);
}

// random background option
function randomBackgr() {
  if (backgroundOption) {
    theInterval = setInterval(() => {
      let randomimage = Math.ceil(Math.random() * imgArray.length); // get random number
      landingPage.style.backgroundImage = `url(./images/landing${randomimage}.jpg)`; // change background
      landingPage.style.transition = "1s ease-in-out";
    }, 6000);
  }
}
randomBackgr();

// Landing Page --------------------- ---------------------
// --------------------- Our Skills Section ---------------------
const ourSkills = document.querySelector(".skills");
const skillProgress = document.querySelectorAll(".skill-progress span");
let skillsOffsetTop = ourSkills.offsetTop;

window.onscroll = () => {
  if (this.scrollY >= skillsOffsetTop) {
    skillProgress.forEach((element) => {
      element.style.width = element.dataset.progress;
    });
  }
};
// Our Skills Section --------------------- ---------------------

// --------------------- Our Gallery Section ---------------------
const galleryImages = document.querySelectorAll(".images-box img");
galleryImages.forEach((img) => {
  img.addEventListener("click", (e) => {
    // create overllay & addi it to body
    let overllay = document.createElement("div");
    overllay.className = "popup-overllay";
    document.body.appendChild(overllay);
    // create popup box
    let popupBox = document.createElement("div");
    popupBox.className = "popup-box";

    // put alt text in head of img
    if (img.alt !== null) {
      let imgHead = document.createElement("h3");
      let imgtext = document.createTextNode(img.alt);

      imgHead.appendChild(imgtext);
      popupBox.appendChild(imgHead);
    }

    // create image
    let popupImage = document.createElement("img");
    popupImage.src = img.src;

    // put img in popup & popup in body
    popupBox.appendChild(popupImage);
    document.body.appendChild(popupBox);

    //create close button
    const closeBtn = document.createElement("span");
    let closeBtnText = document.createTextNode("X");
    closeBtn.appendChild(closeBtnText);
    closeBtn.className = "close-button";
    popupBox.appendChild(closeBtn);

    //close popup with click on overlay
    overllay.addEventListener("click", function (e) {
      document.querySelector(".popup-overllay").remove();
      popupBox.remove();
    });
  });
});
// close button
document.addEventListener("click", (e) => {
  // if popup opned remove it with overlay
  if (e.target.className == "close-button") {
    e.target.parentNode.remove();
    document.querySelector(".popup-overllay").remove();
  }
});

// Our Gallery Section --------------------- ---------------------
// --------------------- Navigation Bullets & Navbar ---------------------
const bullets = document.querySelectorAll(".nav-bullets .bullet");

const allLinks = document.querySelectorAll(".links a");

function scrollToSection(elements) {
  elements.forEach((ele) => {
    ele.addEventListener("click", (e) => {
      e.preventDefault();
      document.querySelector(e.target.dataset.section).scrollIntoView({
        behavior: "smooth",
      });
    });
  });
}
scrollToSection(bullets);
scrollToSection(allLinks);
// Show/hide Navigation Bullets & it's Local Storage
const navigationBullets = document.querySelectorAll(".navigation-bullets span");
const bulletsContainer = document.querySelector(".nav-bullets");
let bulletLocalItem = localStorage.getItem("bulletOption");

if (bulletLocalItem !== null) {
  navigationBullets.forEach((span) => {
    span.classList.remove("active");
  });

  bulletsContainer.style.display = bulletLocalItem;
  if (bulletLocalItem === "block") {
    // bulletsContainer.style.display = "block";
    document.querySelector(".navigation-bullets .yes").classList.add("active");
  } else {
    document.querySelector(".navigation-bullets .no").classList.add("active");
    // localStorage.setItem("bulletOption", "none");
  }
}
navigationBullets.forEach((span) => {
  span.addEventListener("click", (e) => {
    HandleActivStat(e);
    if (span.dataset.display === "yes") {
      bulletsContainer.style.display = "block";
      localStorage.setItem("bulletOption", "block");
    } else {
      bulletsContainer.style.display = "none";
      localStorage.setItem("bulletOption", "none");
    }
  });
});
// Navigation Bullets --------------------- ---------------------

// --------------------- Create Handle State Active Function ---------------------
function HandleActivStat(evnt) {
  // remove active class from all childrens:
  evnt.target.parentElement.querySelectorAll(".active").forEach((elem) => {
    elem.classList.remove("active");
  });
  // add active class on self:
  evnt.target.classList.add("active");
}

/* Toggle Menu */
const togglebtn = document.querySelector(".toggle-menu");
const tlinks = document.querySelector(".links");

tlinks.onclick = function (e) {
  e.stopPropagation();
};
togglebtn.onclick = function (e) {
  e.stopPropagation();
  this.classList.toggle("menu-active");
  tlinks.classList.toggle("open");
};

// click outside toggle-menu
document.addEventListener("click", (e) => {
  if (e.target != togglebtn && e.target != tlinks) {
    if (tlinks.classList.contains("open")) {
      togglebtn.classList.remove("menu-active");
      tlinks.classList.remove("open");
    }
  }
});
