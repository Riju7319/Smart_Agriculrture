document.addEventListener('DOMContentLoaded', () => {
    // 1. Typing Effect
    const textElement = document.querySelector('.typing-text');
    const textToType = "Software Engineer";
    let index = 0;
    let isDeleting = false;

    // Ensure elements exist before running
    if (textElement) {
        function typeEffect() {
            const currentText = textToType;

            if (isDeleting) {
                textElement.textContent = currentText.substring(0, index - 1);
                index--;
            } else {
                textElement.textContent = currentText.substring(0, index + 1);
                index++;
            }

            let typeSpeed = isDeleting ? 100 : 150;

            if (!isDeleting && index === currentText.length) {
                typeSpeed = 2000; // Pause at end
                isDeleting = true;
            } else if (isDeleting && index === 0) {
                isDeleting = false;
                typeSpeed = 500;
            }

            setTimeout(typeEffect, typeSpeed);
        }
        // Start typing
        typeEffect();
    }

    // 2. Smooth Scrolling
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');

            // Handle scroll to top for href="#"
            if (targetId === '#') {
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
                return;
            }

            // Safety check for empty or whitespace-only links
            if (!targetId || targetId.trim() === '') return;

            try {
                const targetElement = document.querySelector(targetId);
                if (targetElement) {
                    targetElement.scrollIntoView({
                        behavior: 'smooth'
                    });
                }
            } catch (error) {
                console.warn("Smooth scroll error:", error);
            }
        });
    });

    // 3. Mobile Menu Toggle
    const menuToggle = document.querySelector('.menu-toggle');
    const navLinks = document.querySelector('.nav-links');

    if (menuToggle && navLinks) {
        // Toggle function
        function toggleMenu(forceClose = false) {
            if (forceClose) {
                navLinks.classList.remove('active');
            } else {
                navLinks.classList.toggle('active');
            }

            // Update Icon
            const icon = menuToggle.querySelector('i');
            if (icon) {
                if (navLinks.classList.contains('active')) {
                    icon.classList.remove('fa-bars');
                    icon.classList.add('fa-times');
                } else {
                    icon.classList.remove('fa-times');
                    icon.classList.add('fa-bars');
                }
            }
        }

        // Toggle on button click
        menuToggle.addEventListener('click', (e) => {
            e.stopPropagation(); // Stop click from propagating to document
            toggleMenu();
        });

        // Close on link click
        navLinks.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', () => {
                toggleMenu(true);
            });
        });

        // Close when clicking outside
        document.addEventListener('click', (e) => {
            // If menu is open AND click is NOT on menu AND click is NOT on toggle button
            if (navLinks.classList.contains('active') &&
                !navLinks.contains(e.target) &&
                !menuToggle.contains(e.target)) {
                toggleMenu(true);
            }
        });
    } else {
        console.warn("Mobile menu elements not found. Check classes: .menu-toggle, .nav-links");
    }
});
