opsworks-cookbooks
==================

Patch nginx server with SSL security

- Forward Secrecy
- Diffie Hellman

requirements:
  - config via opswork chef
  - use custom nginx cookbooks

#With load balancer setup

Find your loadbalancer, in ``listner`` change cipher to use predefined security policy ``ELBSecurityPolicy-2015-05``

#Without load balancer setup

1.Go Opswork Stack

Run ``Update Custom cookbooks`` as stack command


2. Deply an new version of your App

Run ``Deploy`` in your App layer


3. SSH into the server

``
sudo services nginx restart

``

Testing with http://ssllabs.com/ssltest/