(defun packet-hash (line)
  (let ((par_count 0) (buffer 0))
    (loop for ch across line do
          (cond ((char= #\[ ch) (incf par_count))
                ((or (char= #\] ch) (char= #\, ch))
                 (return (+ par_count (* buffer 10))))
            (t (incf buffer (+ (* buffer 10) (digit-char-p ch))))))))

(with-open-file (fp "input.txt" :direction :input)
  (let ((idiv1 2) (idiv2 1) (pachash))
    (loop for line = (read-line fp nil) while line do
          (when (> (length line) 1)
            (setq pachash (packet-hash line))
            (when (< pachash 62) ; Hash value of [[6]] - 62
              (incf idiv1)
              (if (< pachash 22) (incf idiv2))))) ; Hash value of [[2]] - 22
    (print (* idiv1 idiv2))))
