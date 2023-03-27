#!/bin/bash
free | awk 'FNR == 2 {printf("%.1f%%\n"), $3/$2 * 100}'
