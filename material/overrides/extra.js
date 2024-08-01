// Custom JavaScript to run after the page loads
document.addEventListener('DOMContentLoaded', function () {
    console.log('Custom JavaScript loaded!');
    // Example: change theme on page load
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      document.body.classList.add('dark-theme');
    }
  });
