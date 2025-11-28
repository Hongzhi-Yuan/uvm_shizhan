#==============================================================
#  VCS + Built-in UVM(1.2) 前仿 Makefile（增强调试版）
#==============================================================
#  工程结构(根目录):
#   rtl/            - dut/rtl
#   tb/             - testbench, filelist.f, sim_top.sv ...
#   tc/             - uvm test/env/seq ...
#   sim/            - 所有编译/仿真中间与结果输出目录
#
#  特性:
#   1) 使用 VCS 自带的 UVM 库: -ntb_opts uvm-1.2
#   2) 编译/仿真产物统一放到 sim/
#   3) VCS 并行编译: -j$(JOBS)
#   4) 打开增量编译: -Mupdate
#   5) 通过参数 DUMP 控制是否生成 FSDB 波形
#==============================================================


#------------------ 用户可配置 ----------------
TOP      ?= sim_top
TEST     ?= print_env        # 对应 +UVM_TESTNAME
SEED     ?= 1
UVM_VER  ?= uvm-1.2
GUI      ?= 0               # GUI=1 开 DVE/Verdi
COV      ?= 0
JOBS     ?= 24

# 波形配置：DUMP=1 生成 FSDB；DUMP=0 不生成
DUMP     ?= 0
FSDB     ?= wave.fsdb       # 生成在 sim/ 下的文件名


#------------------ 路径/文件 ------------------
RTL_DIR   := rtl
TB_DIR    := tb
TC_DIR    := tc
SIM_DIR   := sim
FILELIST  := $(TB_DIR)/filelist.f


#------------------ 工具 ------------------
VCS    ?= vcs
SIMV   := $(SIM_DIR)/simv
VERDI  ?= verdi


#------------------ 编译选项 ------------------
# 关键点:
#  -Mupdate       增量编译
#  -Mdir/-simv_dir 编译产物进 sim/
#  -debug_access+all -kdb 方便 DVE/Verdi 调试
VCS_OPTS = -full64 -sverilog \
           -timescale=1ns/1ps \
           -ntb_opts $(UVM_VER) \
           -l $(SIM_DIR)/comp.log \
           -Mupdate \
           -Mdir=$(SIM_DIR)/csrc \
           -simv_dir=$(SIM_DIR)/simv.daidir \
           -debug_access+all -kdb \
           +v2k +vpi \
           +warn=NOTPFC \
           -j$(JOBS)

INC_DIRS := +incdir+$(RTL_DIR) \
            +incdir+$(TB_DIR) \
            +incdir+$(TC_DIR)


#------------------ 覆盖率 ------------------
ifeq ($(COV),1)
  VCS_OPTS += -cm line+cond+fsm+tgl+branch \
              -cm_dir $(SIM_DIR)/cov.vdb
  RUN_OPTS += -cm line+cond+fsm+tgl+branch \
              -cm_dir $(SIM_DIR)/cov.vdb
endif


#------------------ GUI ------------------
ifeq ($(GUI),1)
  RUN_OPTS += -gui
endif


#------------------ UVM 运行参数 ------------------
#RUN_OPTS += +UVM_TESTNAME=$(TEST) \
            +ntb_random_seed=$(SEED) \
            +UVM_VERBOSITY=UVM_MEDIUM \
            

RUN_OPTS += +ntb_random_seed=$(SEED) \
            +UVM_VERBOSITY=UVM_MEDIUM \
            +UVM_PHASE_TRACE \
            +UVM_OBJECTION_TRACE


#------------------ 波形开关 ------------------
# DUMP=1 时：
#   1) 编译期开 FSDB 支持并定义宏 DUMP_FSDB
#   2) 运行期传 plusargs: +DUMP_FSDB +FSDB_FILE=xxx.fsdb
ifeq ($(DUMP),1)
  VCS_OPTS += +define+DUMP_FSDB
  RUN_OPTS += +DUMP_FSDB +FSDB_FILE=$(FSDB)
endif


#==============================================================
# Targets
#==============================================================
.PHONY: all comp sim run verdi clean distclean help

all: comp sim


#------------------ 编译 ------------------
comp:
	@mkdir -p $(SIM_DIR)
	$(VCS) $(VCS_OPTS) $(INC_DIRS) \
		-f $(FILELIST) \
		-top $(TOP) \
		-o $(SIMV)


#------------------ 仿真 ------------------
sim: run

run: comp
	@echo "Running TEST=$(TEST), SEED=$(SEED), JOBS=$(JOBS), DUMP=$(DUMP)"
	cd $(SIM_DIR) && ./simv $(RUN_OPTS) -l sim.log


#------------------ 打开 verdi ------------------
# 说明：
# 只有 DUMP=1 且波形存在时才有意义；
# 这里直接指向 sim/$(FSDB)，避免 sim/*.fsdb 为空时报 warning
verdi:
	$(VERDI) -sv -f $(FILELIST) \
		-top $(TOP) \
		-ssf $(SIM_DIR)/$(FSDB) \
	&


#------------------ 清理运行结果(保留编译数据库) ------------------
clean:
	rm -rf $(SIM_DIR)/*.log $(SIM_DIR)/*.fsdb $(SIM_DIR)/*.vpd \
	       $(SIM_DIR)/*.key $(SIM_DIR)/DVEfiles $(SIM_DIR)/verdiLog \
	       $(SIM_DIR)/novas* $(SIM_DIR)/cov.vdb  $(SIM_DIR)/* \
	       novas.*  verdiLog 


#------------------ 深度清理(含增量编译缓存) ------------------
distclean: clean
	rm -rf $(SIM_DIR)/csrc $(SIM_DIR)/simv.daidir $(SIM_DIR)/simv  novas*


help:
	@echo "Usage examples:"
	@echo "  make comp                     # 并行增量编译"
	@echo "  make sim                      # 编译+运行(默认不dump波形)"
	@echo "  make sim TEST=my_test SEED=7  # 指定 testcase/seed"
	@echo "  make sim GUI=1                # GUI 运行"
	@echo "  make sim COV=1                # 打覆盖率"
	@echo "  make sim DUMP=1               # 生成 FSDB 波形(sim/$(FSDB))"
	@echo "  make sim DUMP=1 FSDB=a.fsdb   # 指定 FSDB 文件名"
	@echo "  make verdi DUMP=1             # 打开 verdi (需先生成 FSDB)"
	@echo "  make clean / make distclean   # 清理"

