<img width="638" height="159" alt="Screenshot 2025-07-29 at 1 56 47 AM" src="https://github.com/user-attachments/assets/396d593f-308c-4840-9ef7-c4bfca17b5f7" />

This repository provides **sample code** to access and work with data from the [**RECOVER - Digital Health Data**](https://platform.sb.biodatacatalyst.nhlbi.nih.gov/u/recover/recover-digital-health-data) project on the **Seven Bridges** platform.

---

## Read: Accessing Data in Seven Bridges

This section demonstrates how to **read** data from the Seven Bridges environment, including methods to access data:

#### a. [Per Participant](read/access_dataset.R)
- Fetch data related to a single participant.
- Useful for case-level analysis or validation.

#### b. [Group/List of Participants](read/access_dataset_cohort.R)
- Access data for multiple participants in bulk.
- Supports operations over cohorts or subgroups.

#### c. [Filtering, Summarizing, and Data Modifications](read/access_dataset_adv.R)
- Apply filters to extract subsets of data.
- Perform summarization tasks.

---

## Write: Exporting Results

This section shows how to [**write/save results**](write/write_data.R) (e.g., from Data Studio) back to a designated location within the same Seven Bridges project.

---

## Requirements

- Access to the **Seven Bridges platform** with appropriate project permissions.
- Access to RECOVER project on **Synapse platform**.

---

## Contact

For questions or support, please contact Solly Sieberts (sieberts@sagebase.org)
