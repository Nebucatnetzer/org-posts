(require 'htmlize)
(require 'org-publish-rss)
(require 'ox-publish)
(require 'ox-tufte)

(setopt org-html-html5-fancy t
        org-html-doctype "html5"
        org-html-validation-link nil
        org-html-head-include-scripts nil
        org-html-head-include-default-style nil
        org-html-head "<link rel=\"stylesheet\" href=\"/static/tufte.css\" type=\"text/css\" />
                       <link rel=\"stylesheet\" href=\"/static/ox-tufte.css\" type=\"text/css\" />
                     <link rel=\"alternate\" type=\"application/rss+xml\" title=\"Notes from Andreas Zweili\" href=\"https://zweili.ch/rss.xml\" />"
        org-publish-timestamp-directory "./.cache/"
        org-export-with-section-numbers nil
        )

(defun az/org-html-blog-footer (_info)
  "Return a footer html for org-html export, conditional on BLOG_COMMENTS_THREAD_ID."
  (let* ((thread-id (org-element-map (org-element-parse-buffer)
                        'keyword
                      (lambda (el)
                        (when (string= (org-element-property :key el) "BLOG_COMMENTS_THREAD_ID")
                          (org-element-property :value el)))
                      nil t)))
    (concat
     (when thread-id
       (format
        ;; Comment section
        "<section class=\"outline-2\">
         <h2>Comments</h2>
         <div class=\"outline-text-2\">
         <p>With an account on the Fediverse or Mastodon, you can respond to this post <a href=\"https://social.linux.pizza/@nebucatnetzer/%s\">here</a>. Since Mastodon is decentralized, you can use your existing account hosted by another Mastodon server or compatible platform if you don't have an account on this one.</p>
         </div>
         </section>" (org-html-encode-plain-text thread-id)))

     ;; Actual footer
     "<div>
      <a href=\"https://www.zweili.ch\">Notes</a> © 2025 by <a
         href=\"https://social.linux.pizza/@nebucatnetzer\">Andreas Zweili</a> is licensed under <a
         href=\"https://creativecommons.org/licenses/by-sa/4.0/\">CC BY-SA 4.0
      </a>
      </div>
      <div class=\"generated\">
      Created with Emacs on <a href=\"https://www.gnu.org\">GNU</a>/<a href=\"https://www.kernel.org/\">Linux</a>
      </div>"
     )))

(setopt org-publish-project-alist
        `(("posts"
           :recursive t
           :author "Andreas Zweili"
           :auto-sitemap nil
           :base-directory "./posts"
           :publishing-function  org-tufte-publish-to-html
           :publishing-directory "./public"
           :with-author nil
           :with-creator t
           :with-toc t
           :section-numbers nil
           :time-stamp-file nil
           :html-link-home "https://www.zweili.ch"
           :html-link-up "/"
           :html-postamble az/org-html-blog-footer
           :auto-rss t
           :rss-title "Andreas Zweili's Blog"
           :rss-description "Blog posts on Free Software, technology, etc."
           :rss-with-content all
           :completion-function org-publish-rss
           )

          ("sitemap"
           :auto-sitemap t
           :base-directory "./posts"
           :exclude "index.org"
           :publishing-directory "./public"
           :publishing-function org-html-publish-to-html
           :recursive t
           :sitemap-filename "sitemap.org"
           :sitemap-sort-files anti-chronologically
           :sitemap-style list
           :sitemap-title "Sitemap for Andreas Zweili's notes"
           :sitemap-format-entry
           (lambda (entry style project)
             (format "[[file:%s][%s %s]]"
                     entry
                     (format-time-string "%Y-%m-%d"
                                         (org-publish-find-date entry project))
                     (org-publish-find-title entry project)))
           )

          ("static"
           :base-directory "./posts/"
           :base-extension "txt\\|jpg\\|gif\\|png\\|js"
           :recursive t
           :include ("rss.xml")
           :publishing-directory  "./public/"
           :publishing-function org-publish-attachment)
          ("blog" :components ("sitemap" "posts" "static"))
          )
        )

(org-publish "blog" t)
(message "Build complete!")
