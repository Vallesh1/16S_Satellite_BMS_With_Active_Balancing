# Battery Management System (BMS)

A modular Verilog-based **Battery Management System** designed around a scalable multi-layer architecture with Local Monitoring Units (LMUs), a Master Control Unit (MCU), and a complete top-level integration for pack supervision.

## Overview

This project implements a structured BMS architecture for monitoring, protection, estimation, balancing, communication, and pack-level supervision. The design is organized so that each LMU performs local sensing and safety processing, while the MCU aggregates the data from multiple LMUs to generate final pack-level status and protection decisions.

The overall system is intended to model how a practical battery pack can be supervised in a hierarchical and scalable way. It separates local battery-section intelligence from central pack-level coordination, making the design easier to understand, test, extend, and verify.

## Architecture

The design follows a three-level flow:

1. **LMU Sub-Blocks** – handle measurement, local protection, estimation, balancing, and local communication.
2. **LMU Wrapper / Local Top** – integrates all LMU-level submodules into one complete local monitoring unit.
3. **MCU + 3 LMU Top System** – collects data from three LMUs, computes pack-level decisions, and exposes the final BMS outputs.

```text
                        +----------------------+
                        |   Top-Level BMS      |
                        |  (3 LMUs + 1 MCU)    |
                        +----------+-----------+
                                   |
                 +-----------------+-----------------+
                 |                 |                 |
          +------+-----+    +------+-----+    +------+-----+
          |   LMU 0    |    |   LMU 1    |    |   LMU 2    |
          +------+-----+    +------+-----+    +------+-----+
                 \                 |                 /
                  \                |                /
                   +---------------+---------------+
                                   |
                           +-------+-------+
                           |      MCU      |
                           +---------------+
```

## LMU Sub-Blocks

Each LMU is responsible for one local battery section and contains multiple focused submodules.

### `bms_adc_if`
Interfaces with ADC-side inputs and captures measurement data required for the rest of the local BMS logic.

### `bms_emi_guard`
Checks for EMI-related disturbances and helps prevent unstable or noisy operating conditions from being treated as valid data.

### `bms_isolation_monitor`
Monitors insulation or isolation resistance to detect unsafe leakage or grounding conditions.

### `bms_fault_logger`
Stores and records local fault events for diagnostics and fault history tracking.

### `bms_fault_processor`
Evaluates local faults and converts raw fault conditions into fault flags, codes, and trip-level decisions.

### `bms_soc_soh_engine`
Computes battery state indicators such as:
- **SOC** – State of Charge
- **SOH** – State of Health

### `bms_active_balancer`
Performs balancing support to reduce cell/module imbalance and improve uniformity across the monitored battery section.

### `bms_power_mgmt`
Handles local low-power behavior such as sleep mode and logic clock enable control, helping reduce self-consumption during idle conditions.

## LMU Wrapper / Local Monitoring Unit

### `bms_lmu_wrapper`
The LMU wrapper integrates all LMU-side sub-blocks into one complete local monitoring unit. It acts as the single interface between the local battery section and the higher-level control logic.

Its core responsibilities include:
- collecting local measurement inputs,
- generating SOC/SOH outputs,
- processing local faults,
- controlling balancing-related outputs,
- managing local communication paths,
- supporting local low-power behavior.

This module can be viewed as the **complete local battery supervisor** for one segment of the battery pack.

## Common Communication Modules

These blocks support communication and status transfer across the system.

### `bms_uart_tx`
Provides UART-based transmission of status or diagnostic information.

### `bms_spi_slave`
Supports SPI-based access for configuration, monitoring, or controller interaction.

### `bms_can_status_if`
Formats or exposes BMS status information through a CAN-style communication interface.

### `bms_comm_hub`
Acts as the communication routing or selection block between the available communication interfaces.

## MCU Blocks and Responsibilities

### `bms_master_control_unit_enhanced`
The MCU is the pack-level control and supervision unit. It receives information from all LMUs and converts local information into global pack-level decisions.

Typical responsibilities include:
- polling LMUs,
- averaging SOC and SOH across modules,
- tracking maximum temperature,
- monitoring pack current,
- generating warning/trip decisions,
- aggregating local faults into global fault outputs.

### MCU Supervisory Behavior
The MCU uses configurable protection logic for:
- **current warning and trip thresholds**, 
- **temperature warning and trip thresholds**,
- **LMU count supervision**,
- **fault aggregation and reporting**.

This makes the MCU the **central decision-making block** of the complete BMS.

## Top-Level System

### `bms_system_3lmu_top_enhanced`
This is the final integrated top-level module of the project. It combines:
- **3 Local Monitoring Units (LMUs)**
- **1 Master Control Unit (MCU)**
- common interfaces and system outputs

The top-level module represents the complete BMS and is responsible for exposing pack-level outputs such as:
- average pack SOC,
- average pack SOH,
- global fault status,
- global fault code,
- external communication and supervision signals.

This module demonstrates how individual battery-section monitoring units are combined into a complete hierarchical BMS.

## Functional Flow

The overall functional flow of the system is:

1. Local battery measurements enter each LMU.
2. Each LMU performs sensing, estimation, balancing, and local fault processing.
3. LMU outputs are passed to the MCU.
4. The MCU computes pack-level decisions and final protection results.
5. The top module exposes the complete BMS outputs.

This separation makes the system modular, scalable, and easier to verify.

## Key Features

- Modular Verilog architecture
- Hierarchical BMS organization
- Local monitoring through LMUs
- Centralized pack supervision through MCU
- SOC and SOH estimation support
- Fault logging and fault processing
- Isolation and EMI monitoring
- Active balancing support
- Communication support through UART, SPI, and CAN-style interface
- Low-power support through power-management logic
- Full top-level integration with three LMUs

## Project Structure

```text
rtl/
├── common/
│   ├── bms_uart_tx.v
│   ├── bms_spi_slave.v
│   ├── bms_can_status_if.v
│   └── bms_comm_hub.v
├── lmu/
│   ├── bms_adc_if.v
│   ├── bms_emi_guard.v
│   ├── bms_isolation_monitor.v
│   ├── bms_fault_logger.v
│   ├── bms_fault_processor.v
│   ├── bms_power_mgmt.v
│   ├── bms_soc_soh_engine.v
│   ├── bms_active_balancer.v
│   ├── bms_satellite_top.v
│   └── bms_lmu_wrapper.v
├── mcu/
│   └── bms_master_control_unit_enhanced.v
└── top/
    └── bms_system_3lmu_top_enhanced.v
```

## Verification

The project can be verified at three levels:

- **LMU-level testbench** for validating local block integration
- **MCU-level testbench** for validating aggregation and supervisory behavior
- **Top-level testbench** for validating complete system integration across 3 LMUs and 1 MCU

This layered verification approach makes debugging and development significantly easier.

## Applications

This project can be used as a reference for:
- academic FPGA/ASIC design projects,
- battery management system architecture studies,
- Verilog-based hierarchical digital design learning,
- modular safety-monitoring system design,
- multi-unit supervision and integration practice.

## Notes

This repository is intended to serve both as an implementation reference and as an educational architecture example for hierarchical BMS design in Verilog. The design emphasizes clean block separation, readability, and structured integration between local and global supervision layers.

---

## Authoring Guidance

This README is suitable as a professional repository introduction and can be further customized by adding:
- simulation screenshots,
- waveform captures,
- synthesis results,
- block diagrams,
- future improvements,
- setup and usage instructions.
