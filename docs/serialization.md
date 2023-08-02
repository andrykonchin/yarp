# Serialization

YARP ships with the ability to serialize a syntax tree to a single string. The string can then be deserialized back into a syntax tree using a language other than C. This is useful for using the parsing logic in other tools without having to write a parser in that language. The syntax tree still requires a copy of the original source, as for the most part it just contains byte offsets into the source string.

## Structure

The serialized string representing the syntax tree is composed of three parts: the header, the body, and the constant pool. The header contains information like the version of YARP that serialized the tree. The body contains the actual nodes in the tree. The constant pool contains constants that were interned while parsing.

The header is structured like the following table:

| # bytes | field |
| --- | --- |
| `4` | "YARP" |
| `1` | major version number |
| `1` | minor version number |
| `1` | patch version number |
| varint | the length of the encoding name |
| string | the encoding name |
| varint | number of errors |
| varint | byte length of error |
| string | error string, as byte[] in source encoding |
| ... | more errors |
| varint | number of warnings |
| varint | byte length of warning |
| string | warning string, as byte[] in source encoding |
| ... | more warnings |
| `4` | content pool offset |
| varint | content pool size |

After the header comes the body of the serialized string. The body consistents of a sequence of nodes that is built using a prefix traversal order of the syntax tree. Each node is structured like the following table:

| # bytes | field |
| --- | --- |
| `1` | node type |
| varint | byte offset into the source string where this node begins |
| varint | length of the node in bytes in the source string |

Each node's child is then appended to the serialized string. The child node types can be determined by referencing `config.yml`. Depending on the type of child node, it could take a couple of different forms, described below:

* `node` - A child node that is a node itself. This is structured just as like parent node.
* `node?` - A child node that is optionally present. If the node is not present, then a single `0` byte will be written in its place. If it is present, then it will be structured just as like parent node.
* `node[]` - A child node that is an array of nodes. This is structured as a variable-length integer length, followed by the child nodes themselves.
* `string` - A child node that is a string. For example, this is used as the name of the method in a call node, since it cannot directly reference the source string (as in `@-` or `foo=`). This is structured as a variable-length integer byte length, followed by the string itself (_without_ a trailing null byte).
* `constant` - A variable-length integer that represents an index in the constant pool.
* `constant[]` - A child node that is an array of constants. This is structured as a variable-length integer length, followed by the child constants themselves.
* `location` - A child node that is a location. This is structured as a variable-length integer start followed by a variable-length integer length.
* `location?` - A child node that is a location that is optionally present. If the location is not present, then a single `0` byte will be written in its place. If it is present, then it will be structured just like the `location` child node.
* `location[]` - A child node that is an array of locations. This is structured as a `4` byte length, followed by the locations themselves.
* `uint32` - A child node that is a 32-bit unsigned integer. This is structured as a variable-length integer.

After the syntax tree, the content pool is serialized. This is a list of constants that were referenced from within the tree. The content pool begins at the offset specified in the header. Each constant is structured as:

| # bytes | field |
| --- | --- |
| `4` | the byte offset in the source |
| `4` | the byte length in the source |

At the end of the serialization, the buffer is null terminated.

## Variable-length integers

Variable-length integers are used throughout the serialized format, using the [LEB128](https://en.wikipedia.org/wiki/LEB128) encoding. This drastically cuts down on the size of the serialized string, especially when the source file is large.

## APIs

The relevant APIs and struct definitions are listed below:

```c
// A yp_buffer_t is a simple memory buffer that stores data in a contiguous
// block of memory. It is used to store the serialized representation of a
// YARP tree.
typedef struct {
  char *value;
  size_t length;
  size_t capacity;
} yp_buffer_t;

// Initialize a yp_buffer_t with its default values.
bool yp_buffer_init(yp_buffer_t *);

// Free the memory associated with the buffer.
void yp_buffer_free(yp_buffer_t *);

// Parse and serialize the AST represented by the given source to the given
// buffer.
void yp_parse_serialize(const char *, size_t, yp_buffer_t *);
```

Typically you would use a stack-allocated `yp_buffer_t` and call `yp_parse_serialize`, as in:

```c
void
serialize(const char *source, size_t length) {
  yp_buffer_t buffer;
  if (!yp_buffer_init(&buffer)) return;

  yp_parse_serialize(source, length, &buffer);
  // Do something with the serialized string.

  yp_buffer_free(&buffer);
}
```
