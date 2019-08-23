import Typed from 'typed.js';

const loadDynamicBannerText = () => {
  new Typed('#banner-typed-text', {
    strings: ["Adventures start from good cocktails"],
    typeSpeed: 50,
    loop: true
  });
}

export { loadDynamicBannerText };
