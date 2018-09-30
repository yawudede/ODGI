#!/bin/bash
#SBATCH -o ./dummy_logs/slurm-%j.out
SIZE=512
STAGE2_IMAGE_SIZE=256          
NETWORK='yolov2'

NUM_GPUS=4
BATCH_SIZE=4       
NUM_EPOCHS=50
LEARNING_RATE=1e-3
DELAYED_STAGE2_START=1
sbatch <<EOT
#!/bin/bash
#SBATCH -N 1                            # number of nodes (usually 1)
#SBATCH -n 2                            # number of cores
#SBATCH --mail-user=aroyer@ist.ac.at    # send mail to user
#SBATCH --mail-type=FAIL,END            # if a job fails or ends
#SBATCH --mem 32G                       # memory pool for all cores
#SBATCH --time 5-00:00                  # max runtime (D-HH:MM)
#SBATCH --partition=gpu10cards          # partition (our new GPU servers)
#SBATCH --gres=gpu:2                    # how many GPUs to reserve
#SBATCH --constraint=GTX1080Ti          # GPU type (unnecessary here)
#SBATCH --job-name=odgi-vedai_fold$FOLD-$NETWORK-$SIZE-$STAGE2_IMAGE_SIZE
#SBATCH -o ./log/output_logs/odgi-sdd-$NETWORK-$SIZE-$STAGE2_IMAGE_SIZE-$NUM_EPOCHS.%j.out     # logfile for stdout
#SBATCH -e ./log/error_logs/odgi-sdd-$NETWORK-$SIZE-$STAGE2_IMAGE_SIZE-$NUM_EPOCHS.%j.err      # logfile for stderr

module load cuda/9.0
module load cudnn
module load tensorflow/python3/1.10.0
cd ${HOME}/Jupyter/ODGI                   # working directory

python3 -u train_odgi.py 'sdd' --network=$NETWORK --size=$SIZE --num_epochs=$NUM_EPOCHS --num_gpus=$NUM_GPUS --batch_size=$BATCH_SIZE --stage2_image_size=$STAGE2_IMAGE_SIZE --learning_rate=$LEARNING_RATE --delayed_stage2_start=$DELAYED_STAGE2_START
exit 0
EOT