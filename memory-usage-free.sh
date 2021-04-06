#!/bin/bash
# This is memory-usage-free shell script

export LANG=C, LC_ALL=C

free | awk '
    BEGIN{
        total=0; used=0; available=0; rate=0;
    }

    /^Mem:/{
        total = $2;
        available = $7;
    }

    END {
        used = total - available;
        rate= 100 * used / total;
        printf("total(KB)\tused(KB)\tavailable(KB)\tused-rate(%)\n");
        printf("%d \t %d \t %d \t %.1f\n", total, used, available, rate);
    }';