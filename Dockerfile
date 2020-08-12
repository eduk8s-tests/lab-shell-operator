FROM flant/shell-operator:v1.0.0-beta.10 as shell-operator

FROM quay.io/eduk8s/base-environment:200729.065116.d64688f

COPY --from=shell-operator /shell-operator /opt/eduk8s/bin/

COPY --chown=1001:0 . /home/eduk8s/

RUN mv /home/eduk8s/workshop /opt/workshop

RUN fix-permissions /home/eduk8s
