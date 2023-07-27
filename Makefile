CC = clang
ASM = nasm
LD = $(CC)
MKDIR = mkdir -p
RM = rm -rf
ASMFLAGS = -f elf64

SOLUTION_DIR = solution
BUILD = build
SRCDIR = $(SOLUTION_DIR)/src
INCDIR = $(SOLUTION_DIR)/include
OBJDIR = $(BUILD)/obj
TARGET = $(BUILD)/sepia-filter-test

$(BUILD):
	$(MKDIR) $@

$(OBJDIR):
	$(MKDIR) $@

OBJS_C = $(subst $(SRCDIR), $(OBJDIR), $(patsubst %.c, %.o, $(wildcard $(SRCDIR)/*.c)))
OBJS_ASM = $(subst $(SRCDIR), $(OBJDIR), $(patsubst %.asm, %.o, $(wildcard $(SRCDIR)/*.asm)))
INCLUDES = $(wildcard $(INCDIR)/*.h)
CFLAGS = $(strip $(file < $(SOLUTION_DIR)/compile_flags.txt))

# make c objects
$(OBJDIR)/%.o: $(SRCDIR)/%.c $(INCLUDES) | $(OBJDIR)
	$(CC) -c $< -I $(INCDIR) -o $@ $(CFLAGS)

# make asm objects
$(OBJDIR)/%.o: $(SRCDIR)/%.asm $(INCLUDES) | $(OBJDIR)
	$(ASM) $(ASMFLAGS) -o $@ $<

# %.o: %.asm
#	$(ASM) $(ASMFLAGS) -o $@ $<

# link objects
$(TARGET): $(OBJS_C) $(OBJS_ASM) | $(BUILD)
	$(LD) -lm -o $@ $^

.PHONY: clean all build-all

all: build-all

build-all: $(TARGET)

clean:
	$(RM) $(OBJS_C) $(TARGET)
