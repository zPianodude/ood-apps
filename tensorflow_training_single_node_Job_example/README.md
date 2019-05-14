
# Convolutional neural network training scripts

These scripts implement a number of popular CNN models and demonstrate
efficient training on multi-GPU systems. It can be used for benchmarking,
training and evaluation of models.

Two methods of parallelization are demonstrated.
 * Tensorflow native distributed graphs in nvcnn.py.
 * Uber's Horovod data-parallel framework in nvcnn_hvd.py

## Benchmarking Example

Assumes TFRecord dataset in /data/imagenet_tfrecord.

### nvcnn.py
    $ python nvcnn.py --model=resnet50 \
                      --data_dir=/data/imagenet_tfrecord \
                      --batch_size=64 \
                      --num_gpus=8 \
                      --fp16

### nvcnn_hvd.py
    $ mpiexec --allow-run-as-root -np 8 python nvcnn_hvd.py \
                      --model=resnet50 \
                      --data_dir=/data/imagenet_tfrecord \
                      --batch_size=64 \
                      --fp16

## Training Example

## nvcnn.py
    $ python nvcnn.py --model=resnet50 \
                      --data_dir=/data/imagenet_tfrecord \
                      --batch_size=64 \
                      --num_gpus=8 \
                      --num_epochs=120 \
                      --display_every=50 \
                      --log_dir=/home/train/resnet50-1 \
                      --fp16

## nvcnn_hvd.py
    $ mpiexec --allow-run-as-root -np 8 python nvcnn_hvd.py
                      --model=resnet50 \
                      --data_dir=/data/imagenet_tfrecord \
                      --batch_size=64 \
                      --num_epochs=120 \
                      --display_every=50 \
                      --log_dir=/home/train/resnet50-1 \
                      --fp16

## Use notes

Run with `--help` to see additional arguments.

Add `--eval` to the arguments to evaluate a trained model on the validation
dataset. For nvcnn_hvd.py, only single GPU evaluation is supported.

Add `--fp16` to base the TF model on 16-bit floating-point operations. This
provides optimized performance on Volta's TensorCores. For more information
on training with fp16 arithmetic see [Training with Mixed Precision](
http://docs.nvidia.com/deeplearning/sdk/mixed-precision-training/index.html).

If not executing the container as root, the --allow-run-as-root flag may be
omitted from the commands above.

TensorBoard can be used to monitor training:

    $ tensorboard --logdir=/home/train

## Script details

### Supported models
| Key | Name | Paper |
| alexnet                | AlexNet 'One Weird Trick'  | https://arxiv.org/abs/1404.5997  |
| googlenet              | GoogLeNet                  | https://arxiv.org/abs/1409.4842  |
| vgg11,13,16,19         | Visual Geometry Group ABDE | https://arxiv.org/abs/1409.1556  |
| resnet18,34,50,101,152 | Residual Networks v1       | https://arxiv.org/abs/1512.03385 |
| resnext50,101,152      | ResNeXt                    | https://arxiv.org/abs/1611.05431 |
| inception3             | Inception v3               | https://arxiv.org/abs/1512.00567 |
| inception4             | Inception v4               | https://arxiv.org/abs/1602.07261 |
| inception-resnet2      | Inception-ResNet v2        | https://arxiv.org/abs/1602.07261 |

### Image transformations
The image input pipeline performs the following operations:
 * Random crop and resize
 * Random horizontal flip
 * Random color distortions

### Optimizations
The key optimizations used in this script are:
 * Use `tf.parallel_stack` to construct batches of images.
     * This encodes the parallelism in the graph itself instead of relying on
       Python threads, which are not as efficient as TF's backend thread-pool.
 * Use `StagingArea` to stage input data in host and device memory, and
   explicitly pre-fill them before training begins.
     * This enables overlap of IO and PCIe operations with computation.
 * Use NCHW data format throughout the model.
     * This allows efficient CUDNN convolutions to be used.
 * Use the fused batch normalization op.
     * This is faster than the non-fused version.
 * Apply XLA `jit_scope` to groups of simple bandwidth-bound ops.
     * This allows the ops to be fused together, reducing the number of kernel
       launches and round-trips through memory.
