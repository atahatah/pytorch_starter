import pytorch_lightning as L
import torch
import torch.utils.data as data
from torchvision import datasets
import torchvision.transforms as transforms


class CIFAR10DataModule(L.LightningDataModule):
    """3*32*32 images from CIFAR10 dataset."""

    def __init__(
        self,
        data_dir: str = "/work/data/external",
        num_workers: int = 4,
        train_batch_size: int = 64,
        val_batch_size: int = 128,
        val_rate: float = 0.2,
    ):
        super().__init__()
        self.data_dir = data_dir
        self.num_workers = num_workers
        self.train_batch_size = train_batch_size
        self.val_batch_size = val_batch_size
        self.val_rate = val_rate
        self.transform = transforms.ToTensor()

    def prepare_data(self):
        # download
        datasets.CIFAR10(self.data_dir, train=True, download=True)
        datasets.CIFAR10(self.data_dir, train=False, download=True)

    def setup(self, stage: str):
        # Assign train/val datasets for use in dataloaders
        if stage == "fit":
            mnist_full = datasets.CIFAR10(
                self.data_dir, train=True, transform=self.transform
            )

            train_set_size = int(len(mnist_full) * (1 - self.val_rate))
            valid_set_size = len(mnist_full) - train_set_size

            self.mnist_train, self.mnist_val = data.random_split(
                mnist_full,
                [train_set_size, valid_set_size],
                generator=torch.Generator().manual_seed(42),
            )

        # Assign test dataset for use in dataloader(s)
        if stage == "test":
            self.mnist_test = datasets.CIFAR10(
                self.data_dir, train=False, transform=self.transform
            )

    def train_dataloader(self):
        return data.DataLoader(
            self.mnist_train,
            batch_size=self.train_batch_size,
            num_workers=self.num_workers,
            shuffle=True,
        )

    def val_dataloader(self):
        return data.DataLoader(
            self.mnist_val,
            batch_size=self.val_batch_size,
            num_workers=self.num_workers,
            shuffle=False,
        )

    def test_dataloader(self):
        return data.DataLoader(
            self.mnist_test,
            batch_size=self.val_batch_size,
            num_workers=self.num_workers,
            shuffle=False,
        )
