;; SPDX identifier GPL-3.0-or-later

;; Recorded quantities
(define vehicle-type "")
(define transaction-time (current-seconds))
(define (new-record vehicle-type transaction-time)
  (let ((db (sqlite-open (string-append (system-directory) "/vehicles.db"))))
       (sqlite-query db "create table if not exists vehicle_tbl(type varchar(100), datetime text)")
       (sqlite-query db (string-append "insert into vehicle_tbl values('"vehicle-type"','"
                                    (seconds->string transaction-time "%Y-%m-%d-%H:%M:%S")"')"))
       (sqlite-close db)
       'main))

(define traffic-record (list->table `(
				(main
				 "Digital Traffic Records"
				 ("About" about)
				 #f
				 (spacer height 10)
				 (label text "Msongamano")
				 (spacer height 20)
				 (button color ,Yellow text "Record Traffic" action create-records)
				 (spacer height 10)
				 (button color ,Yellow text "Export Records" action export-records)
				 (spacer)
				)
				(create-records
				 "New Vehicle"
				 ("Back" main)
				 #f
				 (label text "Vehicle Type")
				 (spacer height 10)
				 (button color ,Yellow text "Motorcycle"
                                          action ,(lambda ()
                                                    (set! transaction-time (current-seconds))
                                                    (set! vehicle-type "Motorcycle")
                                                    (new-record vehicle-type transaction-time)))
 				 (spacer height 10)
				 (button color ,Yellow text "Tuk tuk"
                                          action ,(lambda ()
                                                    (set! transaction-time (current-seconds))
                                                    (set! vehicle-type "Tuk tuk")
                                                    (new-record vehicle-type transaction-time)))
 				 (spacer height 10)
				 (button color ,Yellow text "Car"
                                          action ,(lambda ()
                                                    (set! transaction-time (current-seconds))
                                                    (set! vehicle-type "Car")
                                                    (new-record vehicle-type transaction-time)))
 				 (spacer height 10)
                                 (button color ,Yellow text "Pickup / van / jeep / SUV"
                                           action ,(lambda ()
                                                    (set! transaction-time (current-seconds))
                                                    (set! vehicle-type "Pickup / van / jeep / SUV")
                                                    (new-record vehicle-type transaction-time)))
                                 (spacer height 10)
                                 (button color ,Yellow text "Microbus 10-14 seats"
                                           action ,(lambda ()
                                                    (set! transaction-time (current-seconds))
                                                    (set! vehicle-type "Microbus 10-14 seats")
                                                    (new-record vehicle-type transaction-time)))
                                 (spacer height 10)
                                 (button color ,Yellow text "Minibus 15-25 seats"
                                           action ,(lambda ()
                                                    (set! transaction-time (current-seconds))
                                                    (set! vehicle-type "Minibus 15-25 seats")
                                                    (new-record vehicle-type transaction-time)))
                                 (spacer height 10)
                                 (button color ,Yellow text "Bus 26-53 seats"
                                           action ,(lambda ()
                                                    (set! transaction-time (current-seconds))
                                                    (set! vehicle-type "Bus 26-53 seats")
                                                    (new-record vehicle-type transaction-time)))
                                 (spacer height 10)
                                 (button color ,Yellow text "Omnibus 53+ seats"
                                           action ,(lambda ()
                                                    (set! transaction-time (current-seconds))
                                                    (set! vehicle-type "Omnibus 53+ seats")
                                                    (new-record vehicle-type transaction-time)))
                                 (spacer height 10)
                                 (button color ,Yellow text "Light Truck 2 axles"
                                          action ,(lambda ()
                                                    (set! transaction-time (current-seconds))
                                                    (set! vehicle-type "Light Truck 2 axles")
                                                    (new-record vehicle-type transaction-time)))
                                 (spacer height 10)
                                 (button color ,Yellow text "Medium Truck 2 axles"
                                           action ,(lambda ()
                                                    (set! transaction-time (current-seconds))
                                                    (set! vehicle-type "Medium Truck 2 axles")
                                                    (new-record vehicle-type transaction-time)))
                                 (spacer height 10)
                                 (button color ,Yellow text "Heavy Truck 3-4 axles"
                                          action ,(lambda ()
                                                    (set! transaction-time (current-seconds))
                                                    (set! vehicle-type "Heavy Truck 3-4 axles")
                                                    (new-record vehicle-type transaction-time)))
                                 (spacer height 10)
                                 (button color ,Yellow text "Articulated Truck 5-7 axles"
                                          action ,(lambda ()
                                                    (set! transaction-time (current-seconds))
                                                    (set! vehicle-type "Articulated Truck 5-7 axles")
                                                    (new-record vehicle-type transaction-time)))
				 (spacer)
				 )
		                (export-records
				 "Export records as csv"
				 ("Back" main)
				 #f
				 (spacer height 50)
				 (button color ,Yellow text "Export data" action ,(lambda ()
										   (let* ((sysdir (system-directory))
											  (db (sqlite-open (string-append sysdir "/vehicles.db")))
											  (file (string-append sysdir "/vehicles.csv")))
										     (csv-write file (sqlite-query db "select * from vehicle_tbl"))
										     (sqlite-close db))
										   'main))
				 (spacer)
				 )
				(about
				 "About"
				 ("Back" main)
				 #f
				 (spacer height 50)
				 (label text "Record vehicles passing on a lane")
				 )
				)))

(define gui #f)
(define form #f)

(main
;; initialization
  (lambda (w h)
    (make-window 320 480)
    (glgui-orientation-set! GUI_PORTRAIT)
    (set! gui (make-glgui))
    (let* ((w (glgui-width-get))
           (h (glgui-height-get)))
      (glgui-box gui 0 0 w h Blue)
      (set! form (glgui-uiform gui 0 0 w h)))

    (glgui-widget-set! gui form 'sandbox (system-directory))
    (glgui-widget-set! gui form 'uiform traffic-record)

    ;; Set font
    (glgui-widget-set! gui form 'fnt ascii_10.fnt)
 
  )
;; events
  (lambda (t x y)
    (if (= t EVENT_KEYPRESS) (begin
      (if (= x EVENT_KEYESCAPE) (terminate))))
    (glgui-event gui t x y))

;; termination
  (lambda () #t)
;; suspend
  (lambda () (glgui-suspend))
;; resume
  (lambda () (glgui-resume))
)

;; eof
