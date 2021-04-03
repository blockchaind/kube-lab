genca() {
  echo '{"signing":{"default":{"expiry":"43800h","usages":["signing","key encipherment","server auth","client auth"]}}}' > ca-config.json
  echo '{"CN":"CA","key":{"algo":"rsa","size":4096}}' | cfssl gencert -initca - | cfssljson -bare ca -
}

gencert() {
  hostname=${1}
  ip=${2}
  mkdir -p ${hostname} && pushd ${hostname}
  echo '{"CN":"'$hostname'","hosts":[""],"key":{"algo":"rsa","size":4096}}' | \
    cfssl gencert -config=../ca-config.json -ca=../ca.pem -ca-key=../ca-key.pem \
    -hostname="$ip,127.0.0.1,172.16.0.1,172.16.0.121" - | cfssljson -bare $hostname
  popd
}

genca

for i in {1..2}
do
  for j in {1..3}
  do
   gencert "172-16-0-${i}0${j}" "172.16.0.${i}0${j}"
  done
done
