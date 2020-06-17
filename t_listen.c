/*
** t_listen.c - Test daemon for pnscan
**
** Copyright (c) 2002-2020, Peter Eriksson <pen@lysator.liu.se>
** All rights reserved.
** 
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
** 
** 1. Redistributions of source code must retain the above copyright notice, this
**    list of conditions and the following disclaimer.
** 
** 2. Redistributions in binary form must reproduce the above copyright notice,
**    this list of conditions and the following disclaimer in the documentation
**    and/or other materials provided with the distribution.
** 
** 3. Neither the name of the copyright holder nor the names of its
**    contributors may be used to endorse or promote products derived from
**    this software without specific prior written permission.
** 
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
** AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
** IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
** FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
** DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
** SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
** CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
** OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>

int port_base = 32768;
int port_len  = 16384;

int timeout = 10;

const char *msg = "Hello, World!\n";

void
error(const char *msg) {
  fprintf(stderr, "Error: %s: %s\n", msg, strerror(errno));
  exit(1);
}

int
main(int argc,
     char *argv[]) {
  int s_fd, r_fd, port, rc, n;
  struct sockaddr_in s_sin, r_sin;
  socklen_t r_sin_len;
  

  s_fd = socket(PF_INET, SOCK_STREAM, 0);
  if (s_fd < 0)
    error("socket");
  
  n = 0;
  do {
    port = (random()%port_len)+port_base;
    
    memset(&s_sin, 0, sizeof(s_sin));
    s_sin.sin_family = AF_INET;
    s_sin.sin_port = htons(port);

    rc = bind(s_fd, (struct sockaddr *) &s_sin, sizeof(s_sin));
  } while (rc < 0 && (errno == EINTR || errno == EADDRINUSE) && n++ < 10);
  if (rc < 0)
    error("bind");
  
  if (listen(s_fd, 10) < 0)
    error("listen");

  rc = fork();
  if (rc < 0)
    error("fork");
  
  if (rc) {
    printf("%d\n", port);
    exit(0);
  }

  close(0);
  close(1);
  close(2);
  alarm(timeout);
  
  do {
    r_fd = accept(s_fd, (struct sockaddr *) &r_sin, &r_sin_len);
  } while (r_fd < 0 && errno == EINTR);
  
  if (r_fd < 0)
    error("accept");
  
  if (write(r_fd, msg, strlen(msg)) < 0)
    error("write");
  
  close(r_fd);
  _exit(0);
}

