# Health Check in a Docker Container

`Docker` provides a very useful instruction, `HEALTHCHECK`, to check 
the health of service after the container has been initiated. Based 
on [HEALTHCHECK](https://docs.docker.com/engine/reference/builder/#healthcheck) 
instruction, the status of health check can be seen in the `Status` 
column by executing `docker ps`.

The `HEALTHCHECK` instruction accepts two forms, exec form and 
shell form. The demostration of these two forms in the 
following section.


# Use `HEALTHCHECK` instruction in shell form

Based on the example on [HEALTHCHECK](https://docs.docker.com/engine/reference/builder/#healthcheck), the instruction can be written down as:
```dockerfile
HEALTHCHECK CMD curl --fail ${IP}:${PORT} || exit 1
```
> [Learn More](../../dockerfiles/instructions/health-check/shell-form/Dockerfile)
>


# Use `HEALTHCHECK` instruction in exec form

It's quite tricky to assign `|| exit 1` to the exec form, but let's 
see how it goes without `|| exit 1`.
```dockerfile
HEALTHCHECK CMD ["curl", "--fail 0.0.0.0:5478"]
```
> [Learn More](../../dockerfiles/instructions/health-check/exec-form/Dockerfile)
>

Unfortunately, the health check failed.
```bash
otto@laptop ~ - $ docker ps
IMAGE                                CREATED              STATUS
docker.tutorials:health-check-exec   About a minute ago   Up About a minute (health: starting)

otto@laptop ~ - $ docker ps
IMAGE                                CREATED              STATUS
docker.tutorials:health-check-exec   About a minute ago   Up About a minute (unhealthy)
```

If the exec form goes with `sh -c`, then the `|| exit 1` could be 
placed in the same command line as follows:
```dockerfile
HEALTHCHECK CMD ["/bin/sh", "-c", "curl --fail 0.0.0.0:5478 || exit 1"]
```
> [Learn More](../../dockerfiles/instructions/health-check/exec-form/sh-c/Dockerfile)
>

Then `Docker` could get the status of the container.
```bash
otto@Ottos-MacBook-Pro ~ - $ docker ps
IMAGE                                     CREATED          STATUS
docker.tutorials:health-check-exec-sh-c   24 seconds ago   Up 23 seconds (health: starting)

otto@Ottos-MacBook-Pro ~ - $ docker ps
IMAGE                                     CREATED          STATUS
docker.tutorials:health-check-exec-sh-c   36 seconds ago   Up 36 seconds (healthy)
```


# Conclusion

In this case, it's better to use shell form due to the `||` is after 
the `curl` command or to use `sh -c` for exec form.
