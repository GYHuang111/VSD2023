
int main(void ){
    extern int _test_start;
    extern int array_size;
    extern int array_addr; 
    int i,j;
    int min_index, tmp;
    
    for (i = 0; i < array_size - 1; i++)
    {
        min_index = i;
        for(j = i + 1; j < array_size; j++)
        {
            if((&array_addr)[j] < (&array_addr)[min_index])
                min_index = j;
        }
        tmp = (&array_addr)[min_index];
        (&array_addr)[min_index] = (&array_addr)[i];
        (&array_addr)[i] = tmp;
        (&_test_start)[i] = (&array_addr)[i];
    }
    (&_test_start)[array_size - 1] = (&array_addr)[array_size - 1];

    return 0;
}
