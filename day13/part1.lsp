(defmacro dequeue (q) (pop q))
(defun enqueue (q item) 
  (let ((new-last (list item)))
  (if (null (car q))
  (setf (car q) new-last)
  (setf (cddr q) new-last))
  (setf (cdr q) new-last)))

(defun compare-value (left right)
  (if (integerp left)
    (if (integerp right)
      (return-from compare-value (signum (- right left)))
      (return-from compare-value (compare-value (list left) right))))

  (if (integerp right)
    (return-from compare-value (compare-value left (list right))))

  (let ((r))
    (dotimes (_ (min (list-length left) (list-length right)))
      (setq r (compare-value (pop left) (pop right)))
      (if (not (zerop r)) (return-from compare-value r))))

  (compare-value (list-length left) (list-length right)))


(defun fill-queue (fp)
  (let ((buffer 0) (queue (list nil)) (ch))
    (loop
      (setq ch (read-char fp))
      (cond ((char= #\[ ch) (enqueue queue (fill-queue fp)))
            ((char= #\] ch) (enqueue queue buffer) (return queue))
            ((char= #\, ch) 
             (when (not (zerop buffer))
                 (enqueue queue buffer) 
                 (setq buffer 0)))

            (t (setq buffer (+ (* buffer 10) (digit-char-p ch))))))))

(defvar total 0)
(with-open-file (fp "input.txt" :direction :input)
  (let ((i 0) (queue (list nil)))
    (loop while (read-char fp nil) do
          (incf i)
          (setq queue (fill-queue fp))
          (read-char fp)
          (read-char fp)

          (setq total (+ (* i (compare-value queue (fill-queue fp))) i total))

          (read-char fp)
          (read-char fp nil))))

(print (ash total -1))
