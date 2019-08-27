import Typed from 'typed.js';

const loadDynamicBannerText = () => {
  new Typed('#banner-typed-text', {
    strings: ["Find homemade bento near you", "Pickup at a close convenience store", "Connect with chefs near you" ],
    typeSpeed: 80,
    loop: true
  });
}

export { loadDynamicBannerText };
