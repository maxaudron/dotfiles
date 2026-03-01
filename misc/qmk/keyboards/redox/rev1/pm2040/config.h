// Copyright 2022 xerootg
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

#define DEBOUNCE 5
#define DEBOUNCE_TYPE sym_defer_pk

#define BOOTMAGIC_ROW 0
#define BOOTMAGIC_COLUMN 0

/* serial.c configuration for split keyboard */
#define SERIAL_USART_FULL_DUPLEX   // Enable full duplex operation mode.
#undef SOFT_SERIAL_PIN             // Remove define from keyboard.json
#define SERIAL_USART_TX_PIN GP2    // USART TX pin
#define SERIAL_USART_RX_PIN GP3    // USART RX pin
