.PHONY: all status test-solutions clean

all: status

status:
	@echo "=================================================="
	@echo "  SAO: KERNEL - PLAYER PROGRESS STATUS"
	@echo "=================================================="
	@if [ -f .sao_progress ]; then \
		cat .sao_progress; \
	else \
		echo "  まだクリア済みの階層はありません。Floor_01_Gate から開始せよ。"; \
	fi
	@echo "=================================================="

test-solutions:
	@echo "[SYSTEM] 全フロアの模範解答 (.solution) を一括検証中..."
	@for dir in Floor_*; do \
		if [ -f "$$dir/test.sh" ]; then \
			echo ">>> Testing $$dir ..."; \
			(cd "$$dir" && ./test.sh --solution) || exit 1; \
		fi; \
	done
	@echo "[SYSTEM] 全フロアの模範解答テストが正常にPASSしました！"

clean:
	rm -f Floor_*/floor_runner
