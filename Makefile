NAME				:= pong
FCEUX				:= ../fceux/fceux64.exe

TARGET_EXEC	:= $(NAME).nes
TARGET_DBG	:= $(NAME).dbgfile
TARGET_MAP	:= $(NAME).map
TARGET_LAB	:= $(NAME).lab

SRC_DIR			:= ./src
BUILD_DIR		:= ./build
INC_DIR			:= ./include
OBJ_DIR			:= $(BUILD_DIR)/obj

SRCS				:= $(wildcard $(SRC_DIR)/*.asm) $(wildcard $(SRC_DIR)/**/*.asm)
OBJS				:= $(patsubst $(SRC_DIR)/%.asm,$(OBJ_DIR)/%.o,$(SRCS))
DEPS				:= $(OBJS:.o=.d)

INC_DIRS		:= $(sort $(dir $(wildcard $(SRC_DIR)/*) $(wildcard $(SRC_DIR)/**/*)))
INC_FLAGS		:= $(addprefix -I ,$(INC_DIRS))

# Link
$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	ld65 $^ -o $@ -C pong.cfg \
		--dbgfile $(BUILD_DIR)/$(TARGET_DBG) \
		-m $(BUILD_DIR)/$(TARGET_MAP) \
		-Ln $(BUILD_DIR)/$(TARGET_LAB)

# Build
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm
	mkdir -p $(dir $@)
	ca65 -o $@ --debug-info --create-dep "$(patsubst %.o,%.d,$@)" $(INC_FLAGS) $<

run: $(BUILD_DIR)/$(TARGET_EXEC)
	$(FCEUX) $<

clean:
	rm -rf $(BUILD_DIR)

.PHONY: clean run

-include $(DEPS)
