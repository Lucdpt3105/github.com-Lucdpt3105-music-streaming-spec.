// Main JavaScript for Music Streaming App Report

document.addEventListener('DOMContentLoaded', function() {
    // Active link highlighting
    highlightActiveSection();
    
    // Smooth scroll for navigation links
    setupSmoothScroll();
    
    // Lazy load images
    setupLazyLoading();
    
    // Add scroll spy
    setupScrollSpy();
});

// Highlight active section in navigation
function highlightActiveSection() {
    const sections = document.querySelectorAll('.content-section');
    const navLinks = document.querySelectorAll('.sidebar-link');
    
    window.addEventListener('scroll', () => {
        let current = '';
        
        sections.forEach(section => {
            const sectionTop = section.offsetTop;
            const sectionHeight = section.clientHeight;
            if (pageYOffset >= (sectionTop - 200)) {
                current = section.getAttribute('id');
            }
        });
        
        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href').slice(1) === current) {
                link.classList.add('active');
            }
        });
    });
}

// Setup smooth scrolling
function setupSmoothScroll() {
    const links = document.querySelectorAll('a[href^="#"]');
    
    links.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href').slice(1);
            const targetSection = document.getElementById(targetId);
            
            if (targetSection) {
                const offsetTop = targetSection.offsetTop - 20;
                window.scrollTo({
                    top: offsetTop,
                    behavior: 'smooth'
                });
            }
        });
    });
}

// Lazy loading for images
function setupLazyLoading() {
    const images = document.querySelectorAll('img[loading="lazy"]');
    
    if ('IntersectionObserver' in window) {
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.src = img.dataset.src || img.src;
                    img.classList.add('loaded');
                    observer.unobserve(img);
                }
            });
        });
        
        images.forEach(img => imageObserver.observe(img));
    }
}

// Scroll spy for better navigation
function setupScrollSpy() {
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
            }
        });
    }, {
        threshold: 0.1
    });
    
    document.querySelectorAll('.content-section').forEach(section => {
        observer.observe(section);
    });
}

// Back to top button functionality
function addBackToTopButton() {
    const button = document.createElement('button');
    button.innerHTML = '↑';
    button.className = 'back-to-top';
    button.style.cssText = `
        position: fixed;
        bottom: 30px;
        right: 30px;
        background: var(--primary-color);
        color: white;
        border: none;
        border-radius: 50%;
        width: 50px;
        height: 50px;
        font-size: 24px;
        cursor: pointer;
        display: none;
        z-index: 1000;
        transition: all 0.3s ease;
    `;
    
    document.body.appendChild(button);
    
    window.addEventListener('scroll', () => {
        if (window.pageYOffset > 300) {
            button.style.display = 'block';
        } else {
            button.style.display = 'none';
        }
    });
    
    button.addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
}

// Initialize back to top button
addBackToTopButton();

// Table of contents generator (optional)
function generateTableOfContents() {
    const toc = document.querySelector('#table-of-contents');
    if (!toc) return;
    
    const headings = document.querySelectorAll('h2, h3');
    const tocList = document.createElement('ul');
    tocList.className = 'toc-list';
    
    headings.forEach((heading, index) => {
        const li = document.createElement('li');
        const a = document.createElement('a');
        
        if (!heading.id) {
            heading.id = `heading-${index}`;
        }
        
        a.href = `#${heading.id}`;
        a.textContent = heading.textContent;
        a.className = heading.tagName === 'H2' ? 'toc-h2' : 'toc-h3';
        
        li.appendChild(a);
        tocList.appendChild(li);
    });
    
    toc.appendChild(tocList);
}

// Copy code to clipboard functionality
function setupCodeCopyButtons() {
    const codeBlocks = document.querySelectorAll('pre code');
    
    codeBlocks.forEach(block => {
        const button = document.createElement('button');
        button.className = 'copy-code-btn';
        button.textContent = '📋 Copy';
        button.style.cssText = `
            position: absolute;
            top: 5px;
            right: 5px;
            padding: 5px 10px;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        `;
        
        const pre = block.parentElement;
        pre.style.position = 'relative';
        pre.appendChild(button);
        
        button.addEventListener('click', () => {
            navigator.clipboard.writeText(block.textContent).then(() => {
                button.textContent = '✓ Copied!';
                setTimeout(() => {
                    button.textContent = '📋 Copy';
                }, 2000);
            });
        });
    });
}

// Print specific section
function printSection(sectionId) {
    const section = document.getElementById(sectionId);
    if (!section) {
        console.error('Section not found:', sectionId);
        return;
    }

    // Create a new window for printing
    const printWindow = window.open('', '_blank');
    
    // Get styles
    const styles = Array.from(document.styleSheets)
        .map(styleSheet => {
            try {
                return Array.from(styleSheet.cssRules)
                    .map(rule => rule.cssText)
                    .join('\n');
            } catch (e) {
                console.log('Cannot access stylesheet', e);
                return '';
            }
        })
        .join('\n');

    // Build print content
    const printContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <title>Print - ${section.querySelector('h2')?.textContent || 'Section'}</title>
            <style>
                ${styles}
                body { 
                    background: white !important;
                    color: black !important;
                    padding: 20px;
                }
                @media print {
                    .no-print { display: none !important; }
                }
            </style>
        </head>
        <body>
            ${section.innerHTML}
        </body>
        </html>
    `;

    printWindow.document.write(printContent);
    printWindow.document.close();
    
    // Wait for content to load then print
    printWindow.onload = function() {
        printWindow.focus();
        printWindow.print();
        printWindow.onafterprint = function() {
            printWindow.close();
        };
    };
}

// Download file with progress indicator
function downloadFile(url, filename) {
    const link = document.createElement('a');
    link.href = url;
    link.download = filename || url.split('/').pop();
    
    // Show download notification
    showNotification('Đang tải xuống...', 'info');
    
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    // Show success notification after a delay
    setTimeout(() => {
        showNotification('Tải xuống thành công!', 'success');
    }, 500);
}

// Show notification
function showNotification(message, type = 'info') {
    // Remove existing notifications
    const existingNotif = document.querySelector('.custom-notification');
    if (existingNotif) {
        existingNotif.remove();
    }

    const notification = document.createElement('div');
    notification.className = 'custom-notification';
    
    const bgColor = {
        'info': 'bg-blue-600',
        'success': 'bg-green-600',
        'error': 'bg-red-600',
        'warning': 'bg-yellow-600'
    }[type] || 'bg-blue-600';

    notification.innerHTML = `
        <div class="fixed top-4 right-4 ${bgColor} text-white px-6 py-3 rounded-lg shadow-lg z-50 animate-slide-in">
            <div class="flex items-center gap-2">
                ${type === 'success' ? '✓' : type === 'error' ? '✗' : 'ℹ'}
                <span>${message}</span>
            </div>
        </div>
    `;

    document.body.appendChild(notification);

    // Auto remove after 3 seconds
    setTimeout(() => {
        notification.classList.add('animate-slide-out');
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// Export section to PDF (client-side)
async function exportToPDF(sectionId) {
    showNotification('Tính năng đang được phát triển...', 'info');
    
    // You can integrate with libraries like jsPDF or html2pdf.js
    // Example placeholder for future implementation:
    /*
    const element = document.getElementById(sectionId);
    const opt = {
        margin: 1,
        filename: `${sectionId}.pdf`,
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2 },
        jsPDF: { unit: 'in', format: 'letter', orientation: 'portrait' }
    };
    
    // html2pdf().set(opt).from(element).save();
    */
}

// Copy text to clipboard
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(() => {
        showNotification('Đã sao chép vào clipboard!', 'success');
    }).catch(err => {
        showNotification('Không thể sao chép!', 'error');
        console.error('Copy failed:', err);
    });
}

// Generate table of contents dynamically
function generateDynamicTOC() {
    const tocContainer = document.querySelector('#dynamic-toc');
    if (!tocContainer) return;

    const headings = document.querySelectorAll('.content-section h2, .content-section h3');
    const tocList = document.createElement('ul');
    tocList.className = 'space-y-2';

    headings.forEach((heading, index) => {
        if (!heading.id) {
            heading.id = `heading-${index}`;
        }

        const li = document.createElement('li');
        const a = document.createElement('a');
        
        a.href = `#${heading.id}`;
        a.textContent = heading.textContent;
        a.className = heading.tagName === 'H2' 
            ? 'text-primary hover:underline font-semibold' 
            : 'text-secondary hover:text-primary ml-4 text-sm';

        li.appendChild(a);
        tocList.appendChild(li);
    });

    tocContainer.appendChild(tocList);
}

// Check for broken images
function checkBrokenImages() {
    const images = document.querySelectorAll('img');
    images.forEach(img => {
        img.onerror = function() {
            this.src = 'data:image/svg+xml,%3Csvg xmlns="http://www.w3.org/2000/svg" width="400" height="300"%3E%3Crect fill="%23282828" width="400" height="300"/%3E%3Ctext fill="%23999" x="50%25" y="50%25" text-anchor="middle" dy=".3em"%3EImage not found%3C/text%3E%3C/svg%3E';
            this.classList.add('broken-image');
        };
    });
}

// Initialize all features when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    highlightActiveSection();
    setupSmoothScroll();
    setupLazyLoading();
    setupScrollSpy();
    addBackToTopButton();
    generateDynamicTOC();
    checkBrokenImages();
    
    // Setup code copy buttons if code blocks exist
    if (document.querySelectorAll('pre code').length > 0) {
        setupCodeCopyButtons();
    }
});
