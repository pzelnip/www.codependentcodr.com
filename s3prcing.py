"""Calculate rough costs of having things in s3."""


def main():
    """The main entry point."""
    factor = 100000
    standard = int(0.025 * factor)
    ia_1zone = int(0.01104 * factor)
    glacier = int(0.0045 * factor)

    months_in_standard = 1
    months_in_ia = 1
    months_in_glacier = 1
    imgs_per_day = 2 * 24

    size_per_img_in_gb = (180 * 1024) / (1.0 * 2**30)
    data_per_day = size_per_img_in_gb * imgs_per_day
    data_per_month = data_per_day * 30

    standard_cost = data_per_month * standard * months_in_standard
    ia_cost = data_per_month * ia_1zone * months_in_ia
    glacier_cost = data_per_month * glacier * months_in_glacier

    print(f"Standard: ${standard_cost / (1.0 * factor)}")
    print(f"IA: ${ia_cost / (1.0 * factor)}")
    print(f"Glacier: ${glacier_cost / (1.0 * factor)}")
    print("----------------")
    total_cost = (standard_cost + ia_cost + glacier_cost) / (1.0 * factor)
    print(f"Total: ${total_cost}")


if __name__ == "__main__":
    main()
