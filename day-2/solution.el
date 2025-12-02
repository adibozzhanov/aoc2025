;; Run command: `emacs --script solution.el`
;;
;; this could have been a gazillion times more efficient if I could give a shit
;; But unfortunately there is a limited amount of time that my brain is ready to spend
;; writing elisp. I DID NOT have fun writing that and hopefully will never have to write that much
;; raw elisp in my life ever again

(defun process-input (filePath)
  (mapcar #'(lambda (x) (mapcar #'string-to-number (split-string x "-")))
	  (split-string
	   (with-temp-buffer
	     (insert-file-contents filePath)
	     (buffer-string))
	   "\,")))

(defun filter-null (arr) (seq-filter #'(lambda (x) (not (null x))) arr))
(defun flatten (arr) (if arr (append (car arr) (flatten (cdr arr))) nil))

(defun is-invalid-id-1 (x)
  (let ((l (length (number-to-string x)))
	(s (number-to-string x)))
    (if
	(and
	 (= 0 (% l 2))
	 (= (string-to-number (substring s 0 (/ l 2))) (string-to-number (substring s (/ l 2)))))
	x nil)))

(defun f (k s)
  (cond ((= k (length s)) s)
	((> k (length s)) nil)
	(t (let ((left (substring s 0 k))
		 (right (f k (substring s k))))
	     (cond ((null right) nil)
		   ((string-equal left right) left))))))


(defun is-invalid-id-2 (s)
  (if (null (let ((res (filter-null (mapcar #'(lambda (k) (f k (number-to-string s))) (number-sequence 1 (/ (length (number-to-string s)) 2))))))
	      (if (> (length res) 0)
		  (string-to-number (car res))
		nil)))
      nil s))

(defun invalid-ids-in-range (f a b)
  (let ((range (number-sequence a b)))
    (filter-null (mapcar f range))))


(defun solve (fn filePath) (number-to-string (apply '+ (flatten (filter-null (mapcar #'(lambda (x) (invalid-ids-in-range fn (nth 0 x) (nth 1 x))) (process-input filePath)))))))
(defun solve1 (filePath) (solve #'is-invalid-id-1 filePath))
(defun solve2 (filePath) (solve #'is-invalid-id-2 filePath))

(message (solve1 "example.txt"))
(message (solve2 "example.txt"))
(message (solve1 "input.txt"))
(message (solve2 "input.txt"))
