#!/usr/bin/env bash

# This spins up a local PHP server and sends a few requests to test proper
# handling of input data.
# Mails a send to [MailHog](https://github.com/mailhog/MailHog) for analysis.
# [mhsendmail](https://github.com/mailhog/mhsendmail) provides the sendmail-compatible interface
# for php (equivalent to `/usr/sbin/sendmail -S mail:1025`).

PORT=8311

# Start PHP server
php -S 127.0.0.1:$PORT -t public -d "sendmail_path=/usr/local/bin/mhsendmail" &

for room_type in dorm double single; do
  for package in package-a package-b package-c help-week; do
    for payment_method in cash transfer; do
      curl http://127.0.0.1:$PORT/registration.php -s -H "Content-Type: application/x-www-form-urlencoded" \
        -d "registration-type=single&first-name=Eva&last-name=Plast" \
        -d "street=Im Heiligtum&plz=12345&residence=Schönstatt&diocese=Fuuulda" \
        -d "email=test-$room_type.$package.$payment_method@nachtdesheiligtums.de&phone=08942168&date-of-birth=2001-01-01" \
        -d "nutrition-habit=default" \
        -d "room-type=$room_type" \
        -d "package=$package" \
        -d "payment-method=$payment_method" | grep -v \"registration\":true
    done
  done
done

# Stop PHP server
kill $!
