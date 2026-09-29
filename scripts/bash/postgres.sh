# -------------------------- Minikube --------------------------
psql -U postgres
CREATE USER harbor WITH LOGIN PASSWORD 'super-secret-password';
CREATE DATABASE registry OWNER harbor;
\q
psql -U harbor -d registry -W
GRANT ALL ON SCHEMA public TO harbor;
\q
# --------------------------------------------------------------

psql -U postgres
CREATE USER valve WITH LOGIN PASSWORD 'super-secret-password';
CREATE DATABASE valve_stems OWNER valve;
\q
psql -U valve -d valve_stems -W
GRANT ALL ON SCHEMA public TO valve;
\q

psql -U postgres
CREATE USER condenser WITH LOGIN PASSWORD 'super-secret-password';
CREATE DATABASE condenser_calculator OWNER condenser;
\q
psql -U condenser -d condenser_calculator -W
GRANT ALL ON SCHEMA public TO condenser;
\q
