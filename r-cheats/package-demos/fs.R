## ---- fs-pkg-installation
devtools::install_github("r-lib/fs")

## ---- fs-pkg-quick-demo
# Construct a path to a file with `path()`
fs::path("foo", "bar", letters[1:3], ext = "txt")

# list files in the current directory
fs::dir_ls()

# create a new directory
tmp <- fs::dir_create(fs::file_temp())
tmp
# create new files in that directory
fs::file_create(fs::path(tmp, "my-file.txt"))
fs::dir_ls(tmp)
# remove files from the directory
fs::file_delete(fs::path(tmp, "my-file.txt"))
fs::dir_ls(tmp)
# remove the directory
fs::dir_delete(tmp)

# designed to work well with the pipe
paths <- fs::file_temp() %>%
  fs::dir_create() %>%
  fs::path(letters[1:5]) %>%
  fs::file_create()
paths
paths %>% fs::file_delete()
