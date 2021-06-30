FROM angora

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y valgrind python3 && \
    apt-get clean

WORKDIR /fuzzer

COPY Makefile .
COPY executor executor
RUN make
COPY triage triage

CMD /angora/angora_fuzzer -i ${INPUT} -o ${OUTPUT} -t executor/build/taint/rlottie_executor -T 5 -j ${JOB} -- executor/build/fast/rlottie_executor @@